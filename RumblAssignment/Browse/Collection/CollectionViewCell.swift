//
//  CollectionViewCell.swift
//  RumblAssignment
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
	@IBOutlet var cellImageView: UIImageView!

	override func prepareForReuse() {
		cellImageView?.layer.cornerRadius = 10
		cellImageView?.image = #imageLiteral(resourceName: "rumblLogo")
	}

	func setup(
		with cellNode: NodeThumbnail,
		handler: @escaping () -> Void) {
		cellNode.handler = handler
		cellImageView?.image = cellNode.image
	}
}
