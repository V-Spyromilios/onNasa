//
//  CuriosityViewController.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 27.04.23.
//

import UIKit

class CuriosityViewController: UIViewController {
	
	@IBOutlet weak var labelView: UILabel!
	private let viewModel = CuriosityViewModel()
	private var pickerMaxValue: Int?
	
	
	@IBOutlet weak var indicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		indicator.hidesWhenStopped = true
		indicator.startAnimating()
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
