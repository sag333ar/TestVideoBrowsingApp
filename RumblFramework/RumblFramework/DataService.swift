//
//  DataService.swift
//  RumblFramework
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import Foundation

public class DataService {
	public init () { }
	@discardableResult public func getData(
		from url: URL,
		handler: @escaping ([VideosList]?) -> Void) -> URLSessionTask {
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard
				let data = data,
				let elements = try? JSONDecoder().decode([VideosList].self, from: data)
				else {
					OperationQueue.main.addOperation {
						handler(nil)
					}
					return
			}
			OperationQueue.main.addOperation {
				handler(elements)
			}
		}
		task.resume()
		return task
	}
}
