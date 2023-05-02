//
//  RegistrationViewController.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 02.05.23.
//

import UIKit
import RxSwift

class RegistrationViewController: UIViewController {

	@IBOutlet weak var newUsername: UITextField!
	@IBOutlet weak var newPassword: UITextField!
	@IBOutlet weak var registerButton: UIButton!
	@IBOutlet weak var infoButton: UIButton!

	private let viewModel = RegistrationViewModel()
	private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

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
		//TODO: info to show popUp with image Description. title: "Ingenuity at 'Airfield Mu' "
		
	}
 
	private func createBindings() {

		newUsername.rx.text.map{ $0 ?? "" }.bind(to: viewModel.newObservableUsername).disposed(by: bag)
		newPassword.rx.text.map{ $0 ?? "" }.bind(to: viewModel.newObservablePassword).disposed(by: bag)

		viewModel.registrationIsValid().startWith(false).bind(to: registerButton.rx.isEnabled)
			.disposed(by: bag)
		viewModel.registrationIsValid().startWith(false).map { $0 ? 1 : 0.6 }.bind(to: registerButton.rx.alpha)
			.disposed(by: bag)

		registerButton.rx.tap.subscribe(onNext: {
			UserDefaults.standard.set("\(self.newUsername.text!)", forKey: "\(self.newUsername.text!).Username")
		}).disposed(by: bag)

		registerButton.rx.tap.subscribe(onNext: {
			UserDefaults.standard.set("\(self.newPassword.text!)", forKey: "\(self.newUsername.text!).Password")
		}).disposed(by: bag)
	}

}
