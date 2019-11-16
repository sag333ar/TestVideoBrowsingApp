//
//  CollectionViewDataSourceDelegate.swift
//  RumblAssignment
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import UIKit
import RumblFramework

class CollectionViewDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	var didSelect: ((PlayerNavigationContents) -> Void)?
	var nodes: [NodeThumbnail] = []

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		nodes.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 100, height: 135)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
		if let customCell = cell as? CollectionViewCell {
			customCell.setup(with: nodes[indexPath.row]) { [weak self] in
				guard self != nil else { return }
				collectionView.reloadData()
			}
		}
		return cell
	}

	func collectionView(
		_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
	) {
		guard
			let cell = collectionView.cellForItem(at: indexPath)
			else { return }
		didSelect?(PlayerNavigationContents(nodes, selectedIndex: indexPath.row, cell: cell))
	}
}
