//
//  Perseverance View Controller.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import UIKit

class PerseveranceViewController: UIViewController {

	@IBOutlet weak var pickerView: PickerView!
	@IBOutlet weak var labelView: UILabel!
	private let viewModel = PerseveranceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

		createBindings()
    }

	private func createBindings() {

		pickerView.rx.dataSource = 
	}
}
