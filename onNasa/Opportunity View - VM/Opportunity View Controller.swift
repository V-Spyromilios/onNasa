//
//  Opportunity View Controller.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import UIKit

class OpportunityViewController: UIViewController {

	@IBOutlet weak var labelView: UILabel!
	private let viewModel = OpportunityViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

		viewModel.getData(completion: { result in
			guard let result = result, let firstPhoto = result.photos.first else {
				print("OpportunityViewController :: getData :: result is Nil.")
				return
			}
			DispatchQueue.main.async {
				self.labelView.text = firstPhoto.dateTaken
			}
			print("\(firstPhoto.camera.roverId)")
		})
    }
 

}
