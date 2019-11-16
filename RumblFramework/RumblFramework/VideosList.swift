//
//  VideosList.swift
//  RumblFramework
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import Foundation

// MARK: - VideosList
public struct VideosList: Codable {
	public let title: String?
	public let nodes: [Node]?
}

// MARK: - Node
public struct Node: Codable {
	public let video: Video?
}

// MARK: - Video
public struct Video: Codable {
	public let encodeURL: String?
	enum CodingKeys: String, CodingKey {
		case encodeURL = "encodeUrl"
	}
}

public extension String {
	public static var randomString: String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0..<50).map{ _ in letters.randomElement()! })
	}
}
