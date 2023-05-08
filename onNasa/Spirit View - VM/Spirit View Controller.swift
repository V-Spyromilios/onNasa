//
//  Spirit View Controller.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import UIKit
import Alamofire

class SpiritViewController: UIViewController {

	@IBOutlet weak var labelView: UILabel!
	private let viewModel = SpiritViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

		printMaxSol()
    }

	private func printMaxSol() {

		let url = "https://api.nasa.gov/mars-photos/api/v1/manifests/spirit?&api_key=7Pgx3s5ScRMcMlqywqNv1kFwweEd4KAT6MJzNdgZ"
		AF.request(url).validate().responseDecodable(of: MissionManifest.self) { response in
			switch response.result {
			case .success(let manifest):
				print("Spirit MaxSol: \(manifest.manifest.totalSols)")
			case .failure(let error):
				print("Spirit :: printMaxSol-> \(error)")
			}
		}
	}
}
