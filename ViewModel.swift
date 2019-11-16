//
//  ViewModel.swift
//  RumblAssignment
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import Foundation
import RumblFramework

protocol ViewModelRepresentable {
	func didLoad()
	var delegate: ViewRepresentable? { get set }
}

class ViewModel: ViewModelRepresentable {
	weak var delegate: ViewRepresentable?

	func didLoad() {
		if let path = Bundle.main.path(forResource: "assignment", ofType: "json") {
			let fileURL = URL(fileURLWithPath: path)
			delegate?.showHUD()
			DataService().getData(from: fileURL) { [weak self] list in
				guard let self = self else { return }
				self.delegate?.hideHUD()
				self.delegate?.load(with: list ?? [])
			}
		}
	}
}
