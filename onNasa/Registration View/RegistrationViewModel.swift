//
//  RegistrationViewModel.swift
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

	private let bag = DisposeBag()


	func registrationIsValid() -> Observable<Bool> {

		Observable.combineLatest(newObservableUsername.startWith(""), newObservablePassword.startWith("")).map {
			newUsername, newPassword in
			return newUsername?.count ?? 0 > 0 && newPassword?.count ?? 0 > 0
		}
	}
}
