//
//  FullScreenViewController.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 23.05.23.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class FullScreenViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	var image: UIImage? = nil
	private var imageViewConstraints: [NSLayoutConstraint] = []
	private var initialTouchPoint: CGPoint = .zero
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureImageView()
		configureSwipeGesture()
	}
	
	private func  configureImageView() {
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(imageView)

		imageViewConstraints = [
			imageView.topAnchor.constraint(equalTo: view.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		]
		NSLayoutConstraint.activate(imageViewConstraints)
		imageView.image = image
		imageView.contentMode = .scaleAspectFill
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	private func configureSwipeGesture() {
		
		let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
		view.addGestureRecognizer(swipeGesture)
	}
	
	@objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
		
		let touchPoint = gesture.location(in: view.window)
		
		switch gesture.state {
		case .began:
			initialTouchPoint = touchPoint
		case .changed:
			let deltaY = touchPoint.y - initialTouchPoint.y
			if deltaY > 0 {
				view.frame.origin.y = deltaY
			}
		case .ended, .cancelled:
			let dismissThreshold: CGFloat = 100.0
			if touchPoint.y - initialTouchPoint.y > dismissThreshold {
				dismissViewController()
			} else {
				UIView.animate(withDuration: 0.3) { self.view.frame.origin = .zero }
			}
		default:
			break
		}
	}

	private func dismissViewController() {
		UIView.animate(withDuration: 0.3, animations: {
			self.view.frame.origin = CGPoint(x: 0, y: self.view.bounds.size.height)
		}) { _ in
			self.navigationController?.popViewController(animated: true)
		}
	}
	
}
