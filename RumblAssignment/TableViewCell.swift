//
//  TableViewCell.swift
//  RumblAssignment
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import UIKit
import RumblFramework

extension VideosList {
	var collectionNodes: [NodeThumbnail] {
		nodes?.map { NodeThumbnail($0) } ?? []
	}
}

class TableViewCell: UITableViewCell {
	@IBOutlet var titleLabel: UILabel?
	@IBOutlet var collectionView: UICollectionView?

	var collection = CollectionViewDataSourceDelegate()

	func setup(
		with list: VideosList,
		didSelect: ((PlayerNavigationContents) -> Void)?) {
		titleLabel?.text = list.title ?? "No Title"
		collection.nodes = list.collectionNodes
		collection.didSelect = didSelect
		collectionView?.delegate = collection
		collectionView?.dataSource = collection
		collectionView?.reloadData()
	}
}
