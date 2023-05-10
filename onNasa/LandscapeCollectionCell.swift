//
//  LandscapeCollectionCell.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 09.05.23.
//

import UIKit

class LandscapeCollectionCell: UICollectionViewCell {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var button: UIButton!
	@IBOutlet weak var labelView: UILabel!

	override func awakeFromNib() {
		   super.awakeFromNib()

		   contentView.layer.cornerRadius = 8
		   contentView.layer.borderWidth = 1
		   contentView.layer.borderColor = UIColor.clear.cgColor
		   contentView.layer.masksToBounds = true

		   layer.shadowColor = UIColor.black.cgColor
		   layer.shadowOffset = CGSize(width: 0, height: 2.0)
		   layer.shadowRadius = 2.0
		   layer.shadowOpacity = 0.5
		   layer.masksToBounds = false
		   layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
	   }

	   override func layoutSubviews() {
		   super.layoutSubviews()

		   layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
	   }
    
}
