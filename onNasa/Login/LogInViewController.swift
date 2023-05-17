//
//  ViewController.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 27.04.23.
//

import UIKit
import RxSwift
import NotificationCenter

class LogInViewController: UIViewController {
	
	private let viewModel = LoginViewModel()
	private let bag = DisposeBag()
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var loginButtonOutlet: UIButton!
	@IBOutlet weak var registrationButtonOutlet: UIButton!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var nasaImage: UIImageView!
	lazy var backgroundView = UIImageView(frame: self.view.bounds)
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpBackground()
		createBindings()
	}
	
	private func createBindings() {
		
		usernameTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.observableUsername).disposed(by: bag)
		passwordTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.observablePassword).disposed(by: bag)
		
		viewModel.loginIsValid().startWith(false).bind(to: loginButtonOutlet.rx.isEnabled).disposed(by: bag)
		viewModel.loginIsValid().startWith(false).map { $0 ? 1 : 0.5 }.bind(to: loginButtonOutlet.rx.alpha).disposed(by: bag)
		
		loginButtonOutlet.rx.tap.subscribe(onNext: { self.setTabbarAsRoot() }).disposed(by: bag)
		registrationButtonOutlet.rx.tap.subscribe(onNext: {
			self.askPermissionToNotify()
			self.presentRegistationView()
		}).disposed(by: bag)
	}
	
	private func setUpBackground() {
		
		nasaImage.image = UIImage(named: "nasa-logo")
		
		
		backgroundView.image = UIImage(named: "mars")
		backgroundView.contentMode = .scaleAspectFill
		backgroundView.clipsToBounds = true
		backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(backgroundView)
		view.sendSubviewToBack(backgroundView)
		addGesture()
	}
	
	func setTabbarAsRoot() {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let tabbarVC = storyboard.instantiateViewController(withIdentifier: "tabBarID") as! TabBarController
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
		
		UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
			let navController = UINavigationController(rootViewController: tabbarVC)
			window.rootViewController = navController
		}, completion: nil)
	}
	
	private func presentRegistationView() {
		
		let registrationVC = storyboard?.instantiateViewController(identifier: "registrationViewController") as! RegistrationViewController
		show(registrationVC, sender: self)
	}
	
	private func askPermissionToNotify() {
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if granted {
				print("Permission Granted.")
			} else {
				print("Permission Denied.")
			}
		}
	}
	
	private func addGesture() {
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
		tapGesture.numberOfTapsRequired = 2
		backgroundView.addGestureRecognizer(tapGesture)
		backgroundView.isUserInteractionEnabled = true
	}
	
	@objc private func backgroundTapped() {
		
		usernameTextField.resignFirstResponder()
		passwordTextField.resignFirstResponder()
	}
}
