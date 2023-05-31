//
//  LoginViewModel.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 27.04.23.
//

//UserDefaults.standard.set(password, forKey: username)

import Foundation
import RxSwift
import RxCocoa
import FirebaseCore
import FirebaseAuth

class LoginViewModel {

	let observableEmail: BehaviorRelay<String?> = BehaviorRelay(value: nil)
	let observablePassword: BehaviorRelay<String?> = BehaviorRelay(value: nil)


	func emailAndPasswordIsOk() -> Observable<Bool> {
		
		Observable.combineLatest(observableEmail.startWith(""), observablePassword.startWith("")).map { email, password in
			guard let email = email,
				  let password = password else { return false }
			guard
				email.contains("@")
					&& email.count > 9
					&& password.count > 1 else { return false }
			return true
		}
	}

	func signIn(withEmail email: String, password: String, completion: @escaping (Bool) -> Void) {
		FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
			guard let strongSelf = self else { //not to lose self while in async
				completion(false)
				return
			}
			if let error = error {
				print("Sign-in failed with error: \(error.localizedDescription)")
				completion(false)
			} else {
				completion(true)
			}
		}
	}


}

