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
import Kingfisher

class PerseveranceViewController: UIViewController {
	
	@IBOutlet weak var collectionFlow: UICollectionViewFlowLayout!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var pickerView: PickerView!
	@IBOutlet weak var collectionView: UICollectionView!
	private let viewModel = PerseveranceViewModel()
	let spinner = UIActivityIndicatorView()
	
	private let bag = DisposeBag()
	private var pickerMaxValue: Int?
	
	//MARK: CellItem
	struct CellItem {
		let urlSource: String
		let cameraLabelTitle: String
		let buttonSpeakerImage = UIImage(systemName: "speaker.wave.2")
	}
	
	//MARK: PhotoSection
	struct PhotoSection: SectionModelType {
		
		var header: String
		var items: [CellItem]
		typealias Item = CellItem
		
		init(original: PerseveranceViewController.PhotoSection, items: [PerseveranceViewController.CellItem]) {
			self = original
			self.items = items
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		addAndStartSpinner()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		createSectionsAndDataSource()
		getPickerMaxValue()
	}
	
	private func createSectionsAndDataSource() {
		//MARK: dataSource
		let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CellItem>>(configureCell:
			{ (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in

			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "landscapeCollectionCell", for: indexPath) as! LandscapeCollectionCell
			
			if let url = URL(string: item.urlSource) {
				cell.imageView.kf.setImage(
					with: url,
					placeholder: UIImage(named: "nasa-logo"),
					options: [
						.scaleFactor(UIScreen.main.scale),
						.transition(.fade(1)),
						.cacheOriginalImage
					])
			}
			cell.button.setImage(item.buttonSpeakerImage, for: .normal)
			cell.button.alpha = 0.4
			return cell
		},
			configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
			
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionHeader", for: indexPath) as! CollectionHeader
			headerView.labelView.text = dataSource[indexPath.section].model
			return headerView
		}
		) //end of let dataSource...
		let sections = viewModel.perseveranceData
			.map { perseveranceData -> [String: [CellItem]] in
				
				guard let perseveranceData = perseveranceData else { return [:] }
				var itemsDict = [String: [CellItem]]()
				for photo in perseveranceData.photos {
					let cameraName = photo.camera.name
					let imageUrl = photo.urlSource
					let item = CellItem(urlSource: imageUrl, cameraLabelTitle: "\(cameraName)")
					if itemsDict[cameraName] != nil {
						itemsDict[cameraName]?.append(item)
					} else {
						itemsDict[cameraName] = [item]
					}
				}
				return itemsDict
			}
			.map { itemsDict -> [SectionModel<String, CellItem>] in
				
				var sections = [SectionModel<String, CellItem>]()
				let sortedSectionNames = itemsDict.keys.sorted()
				for cameraName in sortedSectionNames {
					if let items = itemsDict[cameraName] {
						let section = SectionModel(model: cameraName, items: items)
						sections.append(section)
					}
				}
				return sections
			}.asDriver(onErrorJustReturn: [])

		sections
			.drive(collectionView.rx.items(dataSource: dataSource))
			.disposed(by: bag)
		sections
			.asObservable()
			.subscribe(onNext: {_ in
				self.spinner.stopAnimating()
			}).disposed(by: bag)
	}

	//MARK: getPickerMaxValue
	private func getPickerMaxValue() {
		
		if let totalSols = viewModel.missionManifest.value?.manifest.totalSols {
			pickerMaxValue = totalSols
		} else { pickerMaxValue = 0 }
	}
	
	//MARK: addAndStartSpinner
	private func addAndStartSpinner() {
		
		spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		spinner.center = collectionView.center
		spinner.style = .large
		spinner.color = UIColor.red
		collectionView.addSubview(spinner)
		spinner.startAnimating()
	}
	
}
