//
//  Spirit View Controller.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 03.05.23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

class SpiritViewController: UIViewController {

	
	@IBOutlet weak var upButton: UIButton!
	@IBOutlet weak var downButton: UIButton!
	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var collectionView: UICollectionView!
	private let viewModel = SpiritViewModel()

	let spinner = UIActivityIndicatorView()
	private let bag = DisposeBag()

	//MARK: PhotoSection
	struct PhotoSection: SectionModelType {
		
		var header: String
		var items: [CellItem]
		typealias Item = CellItem
		
		init(original: SpiritViewController.PhotoSection, items: [CellItem]) {
			self = original
			self.items = items
		}
	}
	
	// MARK: viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		
		createSectionsAndDataSource()
		setupPickerView()
		bindFullScreenToEmittedImage()
	}
	
	//MARK: createSectionsAndDataSource
	private func createSectionsAndDataSource() {
		
		addAndStartSpinner()
		let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CellItem>>(configureCell: {
			(dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spiritCollectionCell", for: indexPath) as! SpiritCollectionCell
			
			cell.configure(with: item)
			return cell
		},
			configureSupplementaryView: {
			(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
			
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionHeader", for: indexPath) as! CollectionHeader
			headerView.labelView.text = dataSource[indexPath.section].model
			return headerView
		}
		) //end of let dataSource...
		collectionView.rx.modelSelected(CellItem.self)
				.subscribe(onNext: { [weak self] item in
					self?.viewModel.fullscreenImageSubject.onNext(ImageCache.default.retrieveImageInMemoryCache(forKey: item.urlSource)!)
				})
				.disposed(by: bag)
		//MARK: sections of UICollection
		let sections = viewModel.spiritData
			.map { spiritData -> [String: [CellItem]] in
				
				guard let spiritData = spiritData else { return [:] }
				var itemsDict = [String: [CellItem]]()
				for photo in spiritData.photos {
					let cameraName = photo.camera.fullName
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
				self.scrollCollectionViewToTop()
			}).disposed(by: bag)
		bindPickerValues()

		viewModel.spiritData
			.subscribe(onNext: { [weak self] photos in
				if photos?.photos.count == 0 {
					self?.showNoImagesAlert()
				}
			})
			.disposed(by: bag)
		
	}
	
	//MARK: scrollCollectionViewToTop
	private func scrollCollectionViewToTop() {
		
		guard collectionView.numberOfSections > 0 && collectionView.numberOfItems(inSection: 0) > 0 else { return }  // No sections or items, no need to scroll !
		let topIndexPath = IndexPath(item: 0, section: 0)
		collectionView.scrollToItem(at: topIndexPath, at: .top, animated: true)
	}
	
	//MARK: bindPickerValues
	private func bindPickerValues() {
		
		viewModel.totalSols
			.map { Array(0...($0 ?? 0)) }
			.bind(to: pickerView.rx.itemTitles) { (_, element) in
				return String(element)
			}
			.disposed(by: bag)
		configureButtons()
	}
	
	//MARK: setupPicker
	///bind picker's selected row to selectedSol
	private func setupPickerView() {
		
		pickerView.rx.modelSelected(Int.self)
			.map { $0.first ?? 0 }
			.bind(to: viewModel.selectedSol)
			.disposed(by: bag)
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
	
	//MARK: configureButtons
	private func configureButtons() {
		
		upButton.addTarget(self, action: #selector(upButtonTapped), for: .touchUpInside)
		upButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
		downButton.addTarget(self, action: #selector(downButtonTapped), for: .touchUpInside)
		downButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
		bindButtonsToSelectedSol()
	}
	
	@objc private func upButtonTapped() {
		incrementSelectedSol()
	}
	
	@objc private func downButtonTapped() {
		decrementSelectedSol()
	}
	
	// MARK: increment - decrement SelectedSol for Buttons
	private func incrementSelectedSol() {
		
		guard let currentIndex = pickerView.selectedRow(inComponent: 0) as Int? else { return }
		
		pickerView.selectRow(currentIndex + 1, inComponent: 0, animated: true)
		viewModel.selectedSol.accept(currentIndex + 1)
	}
	
	private func decrementSelectedSol() {
		
		guard let currentIndex = pickerView.selectedRow(inComponent: 0) as Int?, currentIndex > 0 else { return }
		
		pickerView.selectRow(currentIndex - 1, inComponent: 0, animated: true)
		viewModel.selectedSol.accept(currentIndex - 1)
	}
	
	//MARK: bindButtonsToSelectedSol
	private func bindButtonsToSelectedSol() {
		
		Observable.combineLatest(viewModel.selectedSol, viewModel.totalSols)
			.debounce(.milliseconds(350), scheduler: MainScheduler.instance)
			.bind { [weak self] sol, totalSols in
				if totalSols == 0 {
					// if Mission Manifest (inlc. totalSols) not yet available, disable buttons
					self?.upButton.isEnabled = false
					self?.downButton.isEnabled = false
				} else {
					let pickerMaxValue = totalSols ?? 0
					self?.upButton.isEnabled = sol < pickerMaxValue
					self?.downButton.isEnabled = sol > 0
				}
			}
			.disposed(by: bag)
	}
	
	private func bindFullScreenToEmittedImage() {
		
		viewModel.fullscreenImageSubject
			.subscribe(onNext: { image in
				self.showFullscreenImage(with: image)
			})
			.disposed(by: bag)
	}
	
	private func showFullscreenImage(with image: UIImage) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let fullScreenVC = storyboard.instantiateViewController(withIdentifier: "fullscreen") as! FullScreenViewController
		fullScreenVC.image = image
		fullScreenVC.modalPresentationCapturesStatusBarAppearance = true // FullSreenViewController takes control of the status Bar.
		navigationController?.pushViewController(fullScreenVC, animated: true)
	}

	private func showNoImagesAlert() {
		
		let alert = UIAlertController(title: "No Images Available", message: "There are no images available for the selected sol. Press OK to request images of sol:  \(viewModel.selectedSol.value + 1)", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in

			let currentSol = self?.viewModel.selectedSol.value ?? 0
			self?.pickerView.selectRow(currentSol + 1, inComponent: 0, animated: true)
			self?.viewModel.selectedSol.accept(currentSol + 1)
		}
		alert.addAction(okAction)
		present(alert, animated: true, completion: nil)
	}
}
