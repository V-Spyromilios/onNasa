//
//  Perseverance View Model.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
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
//	private func createItems(from photos: [RoverPhotos.Photo]) -> [SectionModel<Void, cellItem>] {
//		let cellItems = photos.map { photo -> cellItem in
//			let urlString = photo.urlSource
//			let cameraFullName = photo.camera.fullName
//			let image = getImageFromString(source: urlString)
//			return cellItem(image: image, cameraLabelTitle: cameraFullName)
////			 else { return cellItem(image: UIImage(named: "nasa-logo")!, cameraLabelTitle: "") }
//		}
//		let section = SectionModel<Void, cellItem>(model: (), items: cellItems)
//		return [section]
//	}

//	func getImageFromString(source: String) -> UIImage {
//		var image: UIImage?
//			DispatchQueue.global().async  {
//				
//				guard let imageUrl = URL(string: source) else { return }
//				guard let imageData = try? Data(contentsOf: imageUrl) else { return }
//				let image = UIImage(data: imageData)
//			}
//		return image!
//	}
//
//	struct cellItem {
//		
//		let image: UIImage
//		let cameraLabelTitle: String
//		let buttonSpeakerImage = UIImage(systemName: "speaker.wave.2")
//	}

}
