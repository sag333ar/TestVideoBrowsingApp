//
//  VideoThumbnailProvider.swift
//  RumblFramework
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

public class VideoThumbnailProvider {
	public static var shared = VideoThumbnailProvider()
	public func thumbnail(
		for url: URL?,
		using fileManager: FileManager,
		documentDir: String) -> UIImage? {
		guard
			let url = url
			else { return nil }
		guard
			let fileName = url.description.components(separatedBy: "/").last?.components(separatedBy: ".").first
			else { return nil }
		let filePath = "\(documentDir)/\(fileName)"
		let fileURL = URL(fileURLWithPath: filePath)
		if fileManager.fileExists(atPath: filePath),
			let data = try? Data(contentsOf: fileURL),
			let image = UIImage(data: data) {
			return image
		}
		guard
			let cgImage = try? AVAssetImageGenerator(asset: AVURLAsset(url: url, options: nil))
				.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
			else { return nil }
		let image = UIImage(cgImage: cgImage)
		if let data = image.pngData() {
			try? data.write(to: fileURL)
		}
		return image
	}
}

public enum PhotoRecordState {
	case new, downloaded, inProgress, failed
}

public class PhotoRecord {
	public let url: URL?
	public var state = PhotoRecordState.new
	public let fileManager: FileManager
	public let documentDir: String
	public var image: UIImage

	public init(
		_ url: URL?,
		fileManager: FileManager,
		documentDir: String,
		defaultImage: UIImage) {
		self.url = url
		self.fileManager = fileManager
		self.documentDir = documentDir
		self.image = defaultImage
	}
}

public class ImageDownloader: Operation {
	public let photoRecord: PhotoRecord

	public init(_ photoRecord: PhotoRecord) {
		self.photoRecord = photoRecord
	}

	public override func main() {
		if isCancelled {
			photoRecord.state = .failed
			return
		}
		photoRecord.state = .inProgress
		guard
			let url = photoRecord.url,
			let fileName = url.description.components(separatedBy: "/").last?
				.components(separatedBy: ".").first
			else {
				photoRecord.state = .failed
				return
		}
		let filePath = "\(photoRecord.documentDir)/\(fileName).png"
		let fileURL = URL(fileURLWithPath: filePath)
		if photoRecord.fileManager.fileExists(atPath: filePath),
			let data = try? Data(contentsOf: fileURL),
			let image = UIImage(data: data) {
			photoRecord.image = image
			photoRecord.state = .downloaded
			return
		}
		let assetGenerator = AVAssetImageGenerator(asset: AVURLAsset(url: url, options: nil))
		assetGenerator.appliesPreferredTrackTransform = true
		guard
			let cgImage = try? assetGenerator.copyCGImage(
				at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
			else {
				photoRecord.state = .failed
				return
		}
		let image = UIImage(cgImage: cgImage)
		if let data = image.pngData() {
			try? data.write(to: fileURL)
		}
		photoRecord.image = image
		photoRecord.state = .downloaded
	}
}
