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
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.getData(completion: { result in
			guard let result = result, let firstPhoto = result.photos.first else {
				print("CuriocityViewController :: getData :: result is Nil.")
				return
			}
			DispatchQueue.main.async {
				self.labelView.text = firstPhoto.dateTaken
			}
			print("\(firstPhoto.camera.roverId)")
		})
	}

}
