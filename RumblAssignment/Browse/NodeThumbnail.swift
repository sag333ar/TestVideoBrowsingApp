//
//  NodeThumbnail.swift
//  RumblAssignment
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import RumblFramework
import UIKit

extension Node {
	var downloader: ImageDownloader {
		return ImageDownloader(
			PhotoRecord(
				URL(string: video?.encodeURL ?? ""),
				fileManager: FileManager.default,
				documentDir: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0],
				defaultImage: #imageLiteral(resourceName: "rumblLogo"))
		)
	}
}

class NodeThumbnail {
	var node: Node
	var downloader: ImageDownloader? {
		didSet {
			downloader?.completionBlock = {
				if self.downloader?.isCancelled ?? false {
					return
				}
				OperationQueue.main.addOperation {
					self.handler?()
				}
			}
		}
	}

	var handler: (() -> Void)?

	init(_ node: Node) {
		self.node = node
	}

	var image: UIImage {
		if downloader == nil {
			downloader = node.downloader
		}
		if let downloader = downloader {
			switch downloader.photoRecord.state {
				case .new:
					DispatchQueue.global(qos: .background).async {
						downloader.start()
					}
				case .inProgress:
					return #imageLiteral(resourceName: "rumblLogo")
				case .failed:
					self.downloader = node.downloader
				case .downloaded:
					return downloader.photoRecord.image
			}
		}
		return #imageLiteral(resourceName: "rumblLogo")
	}
}
