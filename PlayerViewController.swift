//
//  PlayerViewController.swift
//  RumblAssignment
//
//  Created by sagar kothari on 16/11/19.
//  Copyright © 2019 sagar kothari. All rights reserved.
//

import UIKit
import Hero
import AVKit
import AVFoundation

class PlayerViewController: UIViewController {
	@IBOutlet var delegateContentImageView: UIImageView!
	var heroId: String?
	var contents: PlayerNavigationContents?
	var player: AVPlayer?
	var playerLayer: AVPlayerLayer?

	override func viewDidLoad() {
		super.viewDidLoad()
		delegateContentImageView.hero.id = heroId ?? ""
		self.hero.isEnabled = true
		let swipeG = UISwipeGestureRecognizer(target: self, action: #selector(swipeFromRightToLeft))
		swipeG.direction = .left
		view.addGestureRecognizer(swipeG)
		let swipeT = UISwipeGestureRecognizer(target: self, action: #selector(swipeFromBottomToTop))
		swipeT.direction = .up
		view.addGestureRecognizer(swipeT)
		let swipeB = UISwipeGestureRecognizer(target: self, action: #selector(swipeFromTopToBottom))
		swipeB.direction = .down
		view.addGestureRecognizer(swipeB)
		delegateContentImageView.image = contents?.nodes[contents?.selectedIndex ?? 0].image
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateContents()
	}

	func updateContents() {
		if let contents = contents {
			clearVideo()
			delegateContentImageView.image = contents.nodes[contents.selectedIndex].image
			if let videoString = contents.nodes[contents.selectedIndex].node.video?.encodeURL,
				let url = URL(string: videoString) {
				playVideo(url)
			}
		}
	}

	@objc func swipeFromRightToLeft() {
		dismiss(animated: true, completion: nil)
	}

	@objc func swipeFromBottomToTop() {
		if let contents = contents {
			contents.selectedIndex += 1
			if contents.selectedIndex == contents.nodes.count {
				contents.selectedIndex = 0
			}
			updateContents()
		}
	}

	@objc func swipeFromTopToBottom() {
		if let contents = contents {
			contents.selectedIndex -= 1
			if contents.selectedIndex < 0 {
				contents.selectedIndex = contents.nodes.count - 1
			}
			updateContents()
		}
	}

	@IBAction func backButtonTapped(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}

	func clearVideo() {
		if let player = player {
			player.pause()
		}
		if let playerLayer = playerLayer {
			playerLayer.removeFromSuperlayer()
		}
	}

	func playVideo(_ url: URL) {
		player = AVPlayer(url: url)
		playerLayer = AVPlayerLayer(player: player)
		playerLayer?.frame = delegateContentImageView.bounds
		playerLayer?.videoGravity = .resizeAspectFill
		if let playerLayer = playerLayer {
			delegateContentImageView.layer.addSublayer(playerLayer)
		}
		player?.play()
	}
}
