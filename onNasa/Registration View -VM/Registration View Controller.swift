//
//  Registration View Controller.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 02.05.23.
//

import UIKit
import RxSwift

class RegistrationViewController: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {

	@IBOutlet weak var newUsername: UITextField!
	@IBOutlet weak var newPassword: UITextField!
	@IBOutlet weak var registerButton: UIButton!
	@IBOutlet weak var infoButton: UIButton!
	

	private let viewModel = RegistrationViewModel()
	private let bag = DisposeBag()
	private let infos = InfoTexts()

    override func viewDidLoad() {
        super.viewDidLoad()

		newPassword.delegate = self
		createBindings()
		setBackground()
    }

	private func setBackground() {

		let backgroundView = UIImageView(frame: self.view.bounds)
		backgroundView.image = UIImage(named: "AirfieldMU")
		backgroundView.contentMode = .scaleAspectFill
		backgroundView.clipsToBounds = true
		backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(backgroundView)
		view.sendSubviewToBack(backgroundView)

		infoButton.configuration?.cornerStyle = .capsule
		infoButton.configuration?.image = UIImage(systemName: "info.circle.fill")
	}
 
	private func createBindings() {

		newUsername.rx.text.map{ $0 ?? "" }.bind(to: viewModel.newObservableEmail).disposed(by: bag)
		newPassword.rx.text.map{ $0 ?? "" }.bind(to: viewModel.newObservablePassword).disposed(by: bag)

		viewModel.registrationIsValid().startWith(false).bind(to: registerButton.rx.isEnabled)
			.disposed(by: bag)
		viewModel.registrationIsValid().startWith(false).map { $0 ? 1 : 0.6 }.bind(to: registerButton.rx.alpha)
			.disposed(by: bag)

		registerButton.rx.tap
			.subscribe(onNext: {
				guard let email = self.viewModel.newObservableEmail.value,
					  let password = self.viewModel.newObservablePassword.value else { return }
				
				self.viewModel.registerAccount(withEmail: email, password: password) {
					[weak self] success in
					if success == true {
						self?.presentAlert()
					}
					else { return }
				}
		}).disposed(by: bag)

		infoButton.rx.tap
			.subscribe(onNext: { [weak self] _ in
				self?.performSegue(withIdentifier: "toInfoPopUp", sender: self?.infoButton)
				
			}).disposed(by: bag)

	}

	func presentAlert() {

		let alert = UIAlertController(title: "Welcome!", message: "Account successfully created", preferredStyle: .alert)
				let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
					self?.navigateToLoginView()
				}
				alert.addAction(okAction)
				present(alert, animated: true, completion: nil)
	}

	func navigateToLoginView() {

		if let loginViewController = navigationController?.viewControllers.first as? LogInViewController {
				  navigationController?.popToViewController(loginViewController, animated: true)
			  }
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
			if segue.identifier == "toInfoPopUp",
			   let infoVC = segue.destination as? InfoPopUpController,
			   let infoButton = sender as? UIButton {
				infoVC.popoverPresentationController?.delegate = self
				infoVC.modalPresentationStyle = .overFullScreen
//				infoVC.popoverPresentationController?.backgroundColor = .clear
				infoVC.popoverPresentationController?.sourceView = infoButton
				infoVC.popoverPresentationController?.sourceRect = infoButton.bounds
//				infoVC.popoverPresentationController?.backgroundColor = .label
				infoVC.preferredContentSize = CGSize(width: 220, height: 350)
				infoVC.infoText = infos.registrationInfo
				
			}
		}
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		.none // this way popUp is not presented 'modally' !!
	}
}
