//
//  Spirit View Model.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import Foundation
import RxSwift
import Alamofire


final class SpiritViewModel {
	
	
	func getData(completion: ((RoverPhotos?) -> Void)?) {

		let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/spirit/photos?api_key=7Pgx3s5ScRMcMlqywqNv1kFwweEd4KAT6MJzNdgZ&sol=2"

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
