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
	
	@IBOutlet weak var loginVerticalStack: UIStackView!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var loginButtonOutlet: UIButton!
	@IBOutlet weak var registrationButtonOutlet: UIButton!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var nasaImage: UIImageView!
	lazy var backgroundView = UIImageView(frame: self.view.bounds)
	var offset: CGFloat?
	var keyboardHasAppeared = false
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpBackground()
		createBindings()
		setUpKeyboardMargin()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		emailTextField.becomeFirstResponder()
	}
	
	//MARK: createBindings
	private func createBindings() {
		
		emailTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.observableEmail).disposed(by: bag)
		passwordTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.observablePassword).disposed(by: bag)
		
		viewModel.emailAndPasswordIsOk().startWith(false).bind(to: loginButtonOutlet.rx.isEnabled).disposed(by: bag)
		viewModel.emailAndPasswordIsOk().startWith(false).map { $0 ? 1 : 0.5 }.bind(to: loginButtonOutlet.rx.alpha).disposed(by: bag)
		
		loginButtonOutlet.rx.tap.subscribe(onNext: {
			guard let email = self.viewModel.observableEmail.value,
				  let password = self.viewModel.observablePassword.value else { return }
			
			self.viewModel.signIn(withEmail: email, password: password) { [weak self] success in
				print(success.description)
				if success == true { self?.setTabbarAsRoot() }
				else { return }
			}
		}).disposed(by: bag)
		
		registrationButtonOutlet.rx.tap.subscribe(onNext: {
			self.askPermissionToNotify()
			self.presentRegistationView()
		}).disposed(by: bag)
		
	}
	

	//MARK: setUpBackground
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
	
	//MARK: setTabbarAsRoot
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
	
	//MARK: presentRegistrationView
	private func presentRegistationView() {
		
		let registrationVC = storyboard?.instantiateViewController(identifier: "registrationViewController") as! RegistrationViewController
		show(registrationVC, sender: self)
	}
	
	//MARK: askPermissionToNotify
	private func askPermissionToNotify() {
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if granted {
				print("Permission Granted.")
			} else {
				print("Permission Denied.")
			}
		}
	}
	
	//MARK: addGesture
	private func addGesture() {
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
		tapGesture.numberOfTapsRequired = 1
		backgroundView.addGestureRecognizer(tapGesture)
		backgroundView.isUserInteractionEnabled = true
	}
	
	//MARK: backgroundTapped
	@objc private func backgroundTapped() {
		
		emailTextField.resignFirstResponder()
		passwordTextField.resignFirstResponder()
	}
	
	//MARK: setUpKeyboardMargin
	private func setUpKeyboardMargin() {
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDissapear), name: UIResponder.keyboardWillHideNotification, object: nil)
		
	}
	
	//MARK: keyboardWillAppear
	@objc func keyboardWillAppear(notification: NSNotification) {
		
		///from userInfo DIct the keyboard Frame as ObjC Data Type (also holds key:value) and from this the CoreGraphics rectangle
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			
			let stackBottom = loginVerticalStack.frame.origin.y + loginVerticalStack.frame.height
			let keyboardToViewTop = self.view.frame.height - keyboardSize.height // free space from top of keyboard to view.
			offset = stackBottom - keyboardToViewTop + 40
			guard let offset = offset else { return }
			if offset > 0 {
				adjustSelfView(amount: offset, up: true)
			}
			keyboardHasAppeared = true
		}
	}
	
	//MARK: adjustSelfView
	func adjustSelfView(amount: CGFloat, up: Bool) {
		
		if keyboardHasAppeared { return }
		UIView.animate(withDuration: 0.3, animations: {
			self.view.frame = CGRect(x: self.view.frame.origin.x,
									 y: self.view.frame.origin.y + (up ? -amount : amount),
									 width: self.view.frame.width,
									 height: self.view.frame.height)
		})
	}
	
	//MARK: keyboardWillDissapear
	@objc func keyboardWillDissapear(notification: NSNotification) {
		keyboardHasAppeared = false
		guard let offset = offset,
				offset > 0 else { return }
		adjustSelfView(amount: offset, up: false)
	}
	
}
