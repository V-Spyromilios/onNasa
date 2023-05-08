//
//  Registration View Model.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 02.05.23.
//

import Foundation
import RxSwift
import RxCocoa

final class RegistrationViewModel {

	let newObservableUsername: BehaviorRelay<String?> = BehaviorRelay(value: nil)
	let newObservablePassword: BehaviorRelay<String?> = BehaviorRelay(value: nil)


	func registrationIsValid() -> Observable<Bool> {

		Observable.combineLatest(newObservableUsername.startWith(""), newObservablePassword.startWith("")).map {
			newUsername, newPassword in
			guard newUsername?.count ?? 0 > 0 && newPassword?.count ?? 0 > 0 else { return false }

			return true
			
		}
	}
}
