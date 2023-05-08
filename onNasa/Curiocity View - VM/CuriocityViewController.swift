//
//  CuriocityViewController.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 27.04.23.
//

import UIKit

class CuriocityViewController: UIViewController {
	
	@IBOutlet weak var labelView: UILabel!
	private let viewModel = CuriocityViewModel()
	private var pickerMaxValue: Int?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		getPickerMaxValue()
		createBindings()
		
	}

	private func createBindings() {

		//TODO: Picker to Observe pickerMaxValue

		//TODO: For the CollectionView
		
	}

	private func getPickerMaxValue() {

		if let maxSol = viewModel.missionManifest.value?.manifest.totalSols {
			pickerMaxValue = maxSol
		}
	}
}
