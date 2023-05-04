//
//  Opportunity View Model.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire


final class OpportunityViewModel {
	
	let opportunityData: BehaviorRelay<RoverPhotos?> = BehaviorRelay(value: nil)
	let sol: BehaviorRelay<Int> = BehaviorRelay(value: 0)
	private let bag = DisposeBag()
	
	init() {
		createBindings()
	}
	
	private func createBindings() {
		
		sol.subscribe(onNext: { sol in
			self.getData { photos in
				self.opportunityData.accept(photos)
			}
		}).disposed(by: bag)
	}
	
	
	func getData(completion: ((RoverPhotos?) -> Void)?) {
		
		let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/opportunity/photos?api_key=7Pgx3s5ScRMcMlqywqNv1kFwweEd4KAT6MJzNdgZ&sol=\(sol.value)"
		
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
