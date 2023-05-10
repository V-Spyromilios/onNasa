//
//  Perseverance View Controller.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PerseveranceViewController: UIViewController {
	
	@IBOutlet weak var pickerView: PickerView!
	@IBOutlet weak var collectionView: UICollectionView!
	private let viewModel = PerseveranceViewModel()
	private let bag = DisposeBag()
	private var pickerMaxValue: Int?

	let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Void, cellItem>>(
	
		configureCell: { _, collectionView, indexPath, item in
			if item.image.size.height > item.image.size.width {
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "portraitCollectionCell", for: indexPath) as! PortraitCollectionCell
				cell.imageView.image = item.image
				cell.labelView.text = item.cameraLabelTitle
				cell.labelView.font = UIFont.systemFont(ofSize: 10)
				cell.button.setImage(item.buttonSpeakerImage, for: .normal)
				cell.button.alpha = 0.7
				
				return cell
			}
			else {
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "landscapeCollectionCell", for: indexPath) as! LandscapeCollectionCell
				cell.imageView.image = item.image
				cell.labelView.text = item.cameraLabelTitle
				cell.labelView.font = UIFont.systemFont(ofSize: 10)
				cell.button.setImage(item.buttonSpeakerImage, for: .normal)
				cell.button.alpha = 0.7
				
				return cell
			}
		})

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		getPickerMaxValue()
		createBindings()
	}
	
	private func createBindings() {
		//TODO: Picker to Observe pickerMaxValue

		let Items = viewModel.perseveranceData
			.flatMap{ $0?.photos }
			.map { photo in
				cellItem(image: photo.image ?? UIImage(), cameraLabelTitle: photo.camera.fullName)
			}
//		.map{ $0?.photos ?? [] }
//		.flatMap { $0 }
//		.map{ photo in
//			cellItem(image: photo.image ?? UIImage(), cameraLabelTitle: photo.camera.fullName)
//		}
//		.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
//																					(
//			//			.bind(to: collectionView.rx.items(
//			cellIdentifier: "CollectionCell", cellType: PortraitCollectionCell.self)) {
//				index, photo, cell in
//
//				DispatchQueue.global().async {
//					guard let imageUrl = URL(string: photo.urlSource) else { return }
//
//					guard let imagaData = try? Data(contentsOf: imageUrl) else { return }
//					DispatchQueue.main.async {
//						cell.imageView.image = UIImage(data: imagaData)
//					}
//				}
//			}.disposed(by: bag)
	}
	
	private func getPickerMaxValue() {
		
		if let totalSols = viewModel.missionManifest.value?.manifest.totalSols {
			pickerMaxValue = totalSols
		} else { pickerMaxValue = 0 }
	}

	
}

extension PerseveranceViewController {
	
	struct cellItem {
		
		let image: UIImage
		let cameraLabelTitle: String
		let buttonSpeakerImage = UIImage(systemName: "speaker.wave.2")
	}

	
	
	private func registerCollectionCells() {
		
		collectionView.register(PortraitCollectionCell.self, forCellWithReuseIdentifier: "portraitCollectionCell")
		collectionView.register(LandscapeCollectionCell.self, forCellWithReuseIdentifier: "landscapeCollectionCell")
		collectionView.register(ErrorCollectionCell.self, forCellWithReuseIdentifier: "errorCollectionCell")

	}
}
