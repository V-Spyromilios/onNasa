//
//  TabBar.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 01.05.23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

		tabBar.isTranslucent = true
		tabBar.items?[0].image = UIImage(systemName: "globe.europe.africa.fill")
		tabBar.items?[1].image = UIImage(systemName: "map.fill")
    }
}
