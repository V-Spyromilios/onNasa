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

class LoginViewModel {

	let observableUsername: BehaviorRelay<String?> = BehaviorRelay(value: nil)
	let observablePassword: BehaviorRelay<String?> = BehaviorRelay(value: nil)


	func loginIsValid() -> Observable<Bool> {

		//TODO: Change to search username.Username of UserDefaults LOOK: RegistrationVC::CreteBindings !
		Observable.combineLatest(observableUsername.startWith(""), observablePassword.startWith("")).map { username, password in
			if let _ =  UserDefaults.standard.value(forKey: "\(username!)") as? String {
				return true
			} else { return false }
		}
	}
}

