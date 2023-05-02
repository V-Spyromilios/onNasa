//
//  ViewController.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 27.04.23.
//

import UIKit
import RxSwift

class LogInViewController: UIViewController {

	private let viewModel = LoginViewModel()
	private let bag = DisposeBag()

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var loginButtonOutlet: UIButton!
	@IBOutlet weak var registrationButtonOutlet: UIButton!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var nasaImage: UIImageView!


	
	override func viewDidLoad() {
		super.viewDidLoad()

		setUpBackground()
		createBindings()
	}

	private func createBindings() {

		usernameTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.observableUsername).disposed(by: bag)
		passwordTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.observablePassword).disposed(by: bag)

		viewModel.loginIsValid().startWith(false).bind(to: loginButtonOutlet.rx.isEnabled).disposed(by: bag)
		viewModel.loginIsValid().startWith(false).map { $0 ? 1 : 0.6 }.bind(to: loginButtonOutlet.rx.alpha).disposed(by: bag)

		loginButtonOutlet.rx.tap.subscribe(onNext: { self.presentMainView() }).disposed(by: bag)

		registrationButtonOutlet.rx.tap.subscribe(onNext: { self.presentRegistationView() }).disposed(by: bag)
	}

	private func setUpBackground() {

		nasaImage.image = UIImage(named: "nasa-logo")

		let backgroundView = UIImageView(frame: self.view.bounds)
		backgroundView.image = UIImage(named: "mars")
		backgroundView.contentMode = .scaleAspectFill
		backgroundView.clipsToBounds = true
		backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(backgroundView)
		view.sendSubviewToBack(backgroundView)
	}
	func presentMainView() {
		print("ButtonTapped")
		//		performSegue(withIdentifier: "SegueToTabBar", sender: self)

		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		// init here or just set roor view controller and these inits in the Tabbar Controller ?
		let mainViewController =  storyboard.instantiateViewController(withIdentifier: "mainViewStoryboardID") as! MainViewController
		show(mainViewController, sender: self)
		
		guard let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController else { return }
		let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "mainViewStoryboardID") as! MainViewController
		//		firstVC.labelView.text = "1"
		let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "mainViewStoryboardID") as! MainViewController
		//		secondVC.labelView.text = "2"
		//		thirdVC.labelView.text = "3"
		
		let viewControllers = [firstVC, secondVC]
		tabBarViewController.setViewControllers(viewControllers, animated: true)
		(UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarViewController)
//		present(tabBarViewController, animated: true)
		// TODO: Brave for making the TabBarController 'root'!
		
	}

	private func presentRegistationView() {

		let registrationVC = storyboard?.instantiateViewController(identifier: "registrationViewController") as! RegistrationViewController
		show(registrationVC, sender: self)
	}
}

