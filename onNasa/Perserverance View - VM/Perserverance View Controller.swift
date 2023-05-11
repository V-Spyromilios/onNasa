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
import Alamofire

class PerseveranceViewController: UIViewController {
	
	@IBOutlet weak var pickerView: PickerView!
	@IBOutlet weak var collectionView: UICollectionView!
	private let viewModel = PerseveranceViewModel()
	@IBOutlet weak var indicator: UIActivityIndicatorView!
	private let bag = DisposeBag()
	private var pickerMaxValue: Int?
	
	let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Void, cellItem>>(
		
		configureCell: { _, collectionView, indexPath, item in
			if item.image?.size.height ?? 0 > item.image?.size.width ?? 0 {
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
				cell.labelView.backgroundColor = .systemGray5
				cell.labelView.alpha = 0.7
				cell.labelView.text = item.cameraLabelTitle
				cell.labelView.font = UIFont.systemFont(ofSize: 10)
				cell.button.setImage(item.buttonSpeakerImage, for: .normal)
				cell.button.alpha = 0.7
				
				return cell
			}
		})

	override func viewDidLoad() {
		super.viewDidLoad()
		indicator.startAnimating()
		indicator.backgroundColor = .yellow
		indicator.hidesWhenStopped = true
		if indicator.isAnimating {
			print("Is Rolling!")
		}
		getPickerMaxValue()
		createBindings()
	}

	private func createBindings() {
		//TODO: Picker to Observe pickerMaxValue
		
		viewModel.perseveranceData
			.asObservable()  // BehaviorRelay object to an observable sequence
			.compactMap { $0 }  //OR RxSwiftExt and .unwrap()
			.map { $0.photos }
			.map(createItems)
			.observe(on: MainScheduler.instance)
			.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
		indicator.stopAnimating()
	}

	private func createItems(photos: [RoverPhotos.Photo]) -> [SectionModel<Void, cellItem>] {
		var cellItems: [cellItem] = []
		for photo in photos {
			
			let cameraName = photo.camera.name
			let image = photo.image
			cellItems.append(cellItem(image: image, cameraLabelTitle: cameraName))
		}
		let section = SectionModel<Void, cellItem>(model: (), items: cellItems)
		return [section]
	}
	
	enum ImageLoadingError: Error {
		case invalidURL
		case networkError(Int)
		case invalidImageData
	}
	func getImageDataFromString(source: String) async throws -> Data {
		guard let imageUrl = URL(string: source) else { throw ImageLoadingError.invalidURL }
		
		let (data,  response) = try await URLSession.shared.data(from: imageUrl)
		let httpResponse = response as! HTTPURLResponse
		guard httpResponse.statusCode == 200 else { throw ImageLoadingError.networkError( httpResponse.statusCode) }
			return data
		}

	
	private func getPickerMaxValue() {
		
		if let totalSols = viewModel.missionManifest.value?.manifest.totalSols {
			pickerMaxValue = totalSols
		} else { pickerMaxValue = 0 }
	}
	
}
extension PerseveranceViewController {
	
	struct cellItem {
		
		let image: UIImage?
		let cameraLabelTitle: String
		let buttonSpeakerImage = UIImage(systemName: "speaker.wave.2")
	}

	private func registerCollectionCells() {
		
		collectionView.register(PortraitCollectionCell.self, forCellWithReuseIdentifier: "portraitCollectionCell")
		collectionView.register(LandscapeCollectionCell.self, forCellWithReuseIdentifier: "landscapeCollectionCell")
		collectionView.register(ErrorCollectionCell.self, forCellWithReuseIdentifier: "errorCollectionCell")
	}
}
