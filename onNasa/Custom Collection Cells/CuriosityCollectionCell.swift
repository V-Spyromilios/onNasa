//
//  CuriosityCollectionCell.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 24.05.23.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class CuriosityCollectionCell: UICollectionViewCell {
	
	
	@IBOutlet weak var imageView: UIImageView!
	override func awakeFromNib() {
		super.awakeFromNib()
		
		contentView.layer.cornerRadius = 8
		contentView.layer.borderWidth = 1
		contentView.layer.borderColor = UIColor.clear.cgColor
		contentView.layer.masksToBounds = true
		
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 2.0)
		layer.shadowRadius = 3.0
		layer.shadowOpacity = 0.6
		layer.masksToBounds = false
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		imageView.kf.cancelDownloadTask()
		imageView.image = nil
	}
	
	func configure(with item: CellItem) {
		
		if let url = URL(string: item.urlSource) {
			imageView.kf.setImage(
				with: url,
				placeholder: UIImage(named: "nasa-logo"),
				options: [
					.scaleFactor(UIScreen.main.scale),
					.transition(.fade(1)),
					.cacheOriginalImage
				])
		}
	}
}
