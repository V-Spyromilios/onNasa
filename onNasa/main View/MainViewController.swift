//
//  MainViewController.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 27.04.23.
//

import UIKit

class MainViewController: UIViewController {
	
	@IBOutlet weak var labelView: UILabel!
	let viewModel = MainViewModel()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.getData(completion: { result in
			guard let result = result, let firstPhoto = result.photos.first else {
				print("MainViewController :: getData :: result is Nil.")
				return
			}
			DispatchQueue.main.async {
				self.labelView.text = firstPhoto.urlSource
			}
			print("Total images: \(result.photos.count)")
			print("Image Url: \(firstPhoto.urlSource)")
			print("Date Taken: \(firstPhoto.dateTaken)")
		})
	}
	
}
