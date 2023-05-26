//
//  InfoPopUpController.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 25.05.23.
//

import UIKit
import RxSwift
import RxCocoa

class InfoPopUpController: UIViewController {

	@IBOutlet weak var infoLabel: UILabel!
	var infoText: String?

	override func viewDidLoad() {
        super.viewDidLoad()

		infoLabel.text = infoText
		infoLabel.textColor = .black
		infoLabel.font = .systemFont(ofSize: 13)
		infoLabel.translatesAutoresizingMaskIntoConstraints = false
		infoLabel.textAlignment = .justified
		infoLabel.numberOfLines = 0
    }
 
	@objc func dismissView() {
		self.dismiss(animated: true)
	}
}
