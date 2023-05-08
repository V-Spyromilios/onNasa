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
	let missionManifest: BehaviorRelay<MissionManifest?> = BehaviorRelay(value: nil)
	private let bag = DisposeBag()
	
	init() {

		self.getManifest { result in
			self.missionManifest.accept(result)
		}
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
		
		AF.request(url).validate().responseDecodable(of: RoverPhotos.self) { response in
			switch response.result {
			case .success(let photos):
				completion?(photos)
			case .failure(let error):
				print("Perseverance :: getData -> \(error)")
				completion?(nil)
			}
		}
	}
	
	private func getManifest(completion: ((MissionManifest?) -> Void)?) {
		
		let url = "https://api.nasa.gov/mars-photos/api/v1/manifests/perseverance?&api_key=7Pgx3s5ScRMcMlqywqNv1kFwweEd4KAT6MJzNdgZ"
		
		AF.request(url).validate().responseDecodable(of: MissionManifest.self) { response in
			switch response.result {
			case .success(let manifest):
				completion?(manifest)
			case .failure(let error):
				print("Perseverance :: getManifest -> \(error)")
				completion?(nil)
			}
		}
	}
}
