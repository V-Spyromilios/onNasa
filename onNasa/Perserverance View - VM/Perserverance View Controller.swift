//
//  Perseverance View Controller.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import UIKit
import RxSwift
import RxCocoa

class PerseveranceViewController: UIViewController {
	
	@IBOutlet weak var pickerView: PickerView!
	@IBOutlet weak var labelView: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	private let viewModel = PerseveranceViewModel()
	private let bag = DisposeBag()
	private var pickerMaxValue: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		getPickerMaxValue()
		createBindings()
	}
	
	private func createBindings() {
		//TODO: Picker to Observe pickerMaxValue
		
		//TODO: For the CollectionView
		viewModel.perseveranceData.filter { $0 != nil }.map { $0!.photos}.bind(to: collectionView.rx.items(
//			.bind(to: collectionView.rx.items(
			cellIdentifier: "CollectionCell", cellType: CollectionCell.self)) {
				index, photo, cell in
				
//				let indexPath = IndexPath(item: index, section: 0)
//				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
				

				
				DispatchQueue.global().async {
					guard let imageUrl = URL(string: photo.urlSource) else { return }
					
					guard let imagaData = try? Data(contentsOf: imageUrl) else { return }
					DispatchQueue.main.async {
						cell.imageView.image = UIImage(data: imagaData)
					}
				}
			}.disposed(by: bag)
	}
	
	private func getPickerMaxValue() {
		
		if let totalSols = viewModel.missionManifest.value?.manifest.totalSols {
			pickerMaxValue = totalSols
		} else { pickerMaxValue = 0 }
	}
}
