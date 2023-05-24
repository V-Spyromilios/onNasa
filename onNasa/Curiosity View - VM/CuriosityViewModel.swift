//
//  CuriosityViewModel.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 27.04.23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire


final class CuriosityViewModel {
	
	let curiosityData: BehaviorRelay<RoverPhotos?> = BehaviorRelay(value: nil)
	let selectedSol: BehaviorRelay<Int> = BehaviorRelay(value: 0)
	let missionManifest: BehaviorRelay<MissionManifest?> = BehaviorRelay(value: nil)
	let totalSols = BehaviorRelay<Int?>(value: 0)
	let fullscreenImageSubject = PublishSubject<UIImage>()
	private let bag = DisposeBag()
	
	init() {

		self.getManifest { result in
			self.missionManifest.accept(result)
			self.totalSols.accept(result?.manifest.totalSols)
		}
		createBindings()

	}
	
	private func createBindings() {
		selectedSol
			.debounce(.milliseconds(350), scheduler: MainScheduler.instance) // to avoid multiple 'explicitlyCancelled'
			.flatMapLatest { [weak self] sol -> Observable<RoverPhotos?> in
				guard let self = self else { return .just(nil) }
				return self.getData(for: sol)
			}
			.bind(to: curiosityData)
			.disposed(by: bag)
		print("Selected Sol from ViewModel: \(selectedSol.value)")
	}
	
	private func getData(for sol: Int) -> Observable<RoverPhotos?> {

		guard let apiKey = Configuration.apiKey else {
			print("API key not found in configuration.")
			return Observable.error(APIKeyError.unknownKey)
		}
		print("Data asked")
		
		let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=\(apiKey)&sol=\(sol)"
		
		return Observable.create { observer in
			let request = AF.request(url).validate().responseDecodable(of: RoverPhotos.self) { response in
				switch response.result {
				case .success(let photos):
					observer.onNext(photos)
					observer.onCompleted()
				case .failure(let error):
					print("Curiosity :: getData -> \(error)")
					observer.onNext(nil)
					observer.onCompleted()
				}
			}
			
			return Disposables.create {
				request.cancel()
			}
		}
	}
	
	private func getManifest(completion: ((MissionManifest?) -> Void)?) {
		
		guard let apiKey = Configuration.apiKey else {
			print("getManifest :: API key not found in configuration.")
			return
		}
		
		let url = "https://api.nasa.gov/mars-photos/api/v1/manifests/curiosity?&api_key=\(apiKey)"
		
		AF.request(url).validate().responseDecodable(of: MissionManifest.self) { response in
			switch response.result {
			case .success(let manifest):
				completion?(manifest)
			case .failure(let error):
				print("Curiosity :: getManifest -> \(error)")
				completion?(nil)
			}
		}
	}
}
