//
//  TableViewDelegateDataSource.swift
//  RumblAssignment
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import UIKit
import RumblFramework

class TableViewDelegateDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
	var list: [VideosList] = []
	var didSelect: ((PlayerNavigationContents) -> Void)?

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		list.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		if let customCell = cell as? TableViewCell {
			customCell.setup(with: list[indexPath.row], didSelect: didSelect)
		}
		return cell
	}
}
