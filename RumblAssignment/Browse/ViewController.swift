//
//  ViewController.swift
//  RumblAssignment
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import UIKit
import RumblFramework
import MBProgressHUD
import Hero

protocol ViewRepresentable: class {
	func load(with list: [VideosList])
	func showHUD()
	func hideHUD()
}

class PlayerNavigationContents {
	var nodes: [NodeThumbnail] = []
	var selectedIndex: Int = 0
	var cell: UICollectionViewCell?
	init(
		_ nodes: [NodeThumbnail],
		selectedIndex: Int,
		cell: UICollectionViewCell
	) {
		self.nodes = nodes
		self.selectedIndex = selectedIndex
		self.cell = cell
	}
}

class ViewController: UIViewController {
	@IBOutlet var tableDataSourceDelegate: TableViewDelegateDataSource!
	@IBOutlet var tableView: UITableView!
	var viewModel: ViewModelRepresentable = ViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		hero.isEnabled = true
		viewModel.delegate = self
		viewModel.didLoad()
		tableView.tableFooterView = UIView()
		tableDataSourceDelegate.didSelect = showPlayer
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		title = ""
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		title = "Explore"
	}

	func showPlayer(_ navigation: PlayerNavigationContents) {
		performSegue(withIdentifier: "showPlayer", sender: navigation)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showPlayer",
			let destination = segue.destination as? PlayerViewController,
			let navigation = sender as? PlayerNavigationContents {
			let heroId = String.randomString
			navigation.cell?.hero.id = heroId
			destination.heroId = heroId
			destination.contents = navigation
		}
	}
}

extension ViewController: ViewRepresentable {
	func load(with list: [VideosList]) {
		self.tableDataSourceDelegate.list = list
		self.tableView.reloadData()
	}

	func showHUD() {
		MBProgressHUD.showAdded(to: view, animated: true)
	}

	func hideHUD() {
		MBProgressHUD.hide(for: view, animated: true)
	}
}
