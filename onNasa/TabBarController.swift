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

		setTabBarItems()

    }


	private func setTabBarItems() {

		tabBar.isTranslucent = true
//		let tabbarItem = UITabBarItem(title: "Perserverance", image: UIImage(named: "perserverance"), tag: 2)
//		tabBar.items?[0] = tabbarItem
//		tabBar.items?[0].image = UIImage(named: "perserverance")
//		tabBar.items?[1].image = UIImage(named: "curiocity")
//		tabBar.items?[2].image = UIImage(named: "opportunity")
//		tabBar.items?[3].image = UIImage(named: "spirit")

		tabBar.items?[0].title = "Perserverance"
		
		tabBar.items?[1].title = "Curiocity"
		tabBar.items?[2].title = "Opportunity"
		tabBar.items?[3].title = "Spirit"
		tabBar.tintColor = .red
//		tabBar.itemPositioning = .centered
//		tabBar.itemSpacing = 20
		
		let attributes = [
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .semibold)
		]
		let appearance = UITabBarAppearance()
		appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
		tabBar.standardAppearance = appearance

		}
}

extension TabBarController {
	
}
