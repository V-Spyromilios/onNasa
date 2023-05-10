//
//  Opportunity View Controller.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import UIKit
import Alamofire

class OpportunityViewController: UIViewController {

	@IBOutlet weak var labelView: UILabel!
	private let viewModel = OpportunityViewModel()
	private var pickerMaxValue: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

		pickerMaxValue = viewModel.maxSol
		printMaxSol()
		createBindings()
    }
 

	private func createBindings() {

		//TODO: Update Picker's max Value with pickerMaxValue
		//TODO: For the CollectionView
	}

	private func printMaxSol() {

		let url = "https://api.nasa.gov/mars-photos/api/v1/manifests/opportunity?&api_key=7Pgx3s5ScRMcMlqywqNv1kFwweEd4KAT6MJzNdgZ"
		AF.request(url).validate().responseDecodable(of: MissionManifest.self) { response in
			switch response.result {
			case .success(let manifest):
				print("Opportunity MaxSol: \(manifest.manifest.totalSols)")
			case .failure(let error):
				print("Opportunity :: printMaxSol-> \(error)")
			}
		}
	}
}
