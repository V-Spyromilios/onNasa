//
//  LandscapeCollectionCell.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 09.05.23.
//

import UIKit
import Kingfisher

class LandscapeCollectionCell: UICollectionViewCell {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var button: UIButton!

	override func awakeFromNib() {
		   super.awakeFromNib()

		   contentView.layer.cornerRadius = 8
		   contentView.layer.borderWidth = 1
		   contentView.layer.borderColor = UIColor.clear.cgColor
		   contentView.layer.masksToBounds = true

		   layer.shadowColor = UIColor.black.cgColor
		   layer.shadowOffset = CGSize(width: 0, height: 2.0)
		   layer.shadowRadius = 5.0
		   layer.shadowOpacity = 0.9
		   layer.masksToBounds = false
	   }

	override func prepareForReuse() {
		   super.prepareForReuse()

		   imageView.kf.cancelDownloadTask()
		   imageView.image = nil
	   }
}
