//
//  Perseverance View Model.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire


final class PerseveranceViewModel {

	let perseveranceData: BehaviorRelay<RoverPhotos?> = BehaviorRelay(value: nil)
	let selectedSol: BehaviorRelay<Int> = BehaviorRelay(value: 0)
	private let bag = DisposeBag()
	
	init() {
		createBindings()
	}
	
	private func createBindings() {

		selectedSol.subscribe(onNext: { sol in
			self.getData { photos in
				self.perseveranceData.accept(photos)
			}
		}).disposed(by: bag)
		}
	
	private func getData(completion: ((RoverPhotos?) -> Void)?) {
		
		let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?api_key=7Pgx3s5ScRMcMlqywqNv1kFwweEd4KAT6MJzNdgZ&sol=\(selectedSol.value)"
		
		AF.request(url)
			.validate()
			.responseDecodable(of: RoverPhotos.self) { response in
				switch response.result {
				case .success(let result):
					completion?(result)
				case .failure(let error):
					print("\(error)")
					completion?(nil)
				}
			}
	}
}
