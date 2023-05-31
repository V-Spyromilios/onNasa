//
//  Registration View Model.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 02.05.23.
//

import Foundation
import RxSwift
import RxCocoa
//import Firebase
import FirebaseAuth
import FirebaseCore

final class RegistrationViewModel {

	let newObservableEmail: BehaviorRelay<String?> = BehaviorRelay(value: nil)
	let newObservablePassword: BehaviorRelay<String?> = BehaviorRelay(value: nil)


	func registrationIsValid() -> Observable<Bool> {

		Observable.combineLatest(newObservableEmail.startWith(""), newObservablePassword.startWith("")).map {
			newEmail, newPassword in
			
			guard let newEmail = newEmail,
				  let newPassword = newPassword else { return false }
			guard
				newEmail.contains("@")
					&& newEmail.count > 9
					&& newPassword.count > 6 else { return false }
			return true
		}
	}

	func registerAccount(withEmail email: String, password: String, completion: @escaping (Bool) -> Void) {

		Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in

			guard let StrongSelf = self else { completion(false)
				return
			}

			if let error = error {
				print("Registration failed with error: \(error.localizedDescription)")
				completion(false)
			}
			else { completion(true) }
		}
	}

}
