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
//		let myArray: [Int]? = nil
//		let _ = myArray![2] //Check Crashlytics

		tabBar.items?[0].title = "Persy"
		tabBar.items?[1].title = "Curiosity"
		tabBar.items?[2].title = "Opportunity"
		tabBar.items?[3].title = "Spirit"
		tabBar.items?[4].title = "More"
		
		let tabBarAppearance = UITabBarAppearance()
		tabBarAppearance.backgroundColor = .systemGray5
		tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)]
		tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.red
		
		tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 13, weight: .regular)]
		tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
		
		
		tabBarAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)]
		tabBarAppearance.compactInlineLayoutAppearance.selected.iconColor = UIColor.red
		
		tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 13, weight: .regular)]
		tabBarAppearance.compactInlineLayoutAppearance.normal.iconColor = UIColor.black
		
		tabBarAppearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)]
		tabBarAppearance.inlineLayoutAppearance.selected.iconColor = UIColor.red
		
		tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 13, weight: .regular)]
		tabBarAppearance.inlineLayoutAppearance.normal.iconColor = UIColor.black
		
		tabBarAppearance.stackedItemPositioning = .centered
		
		tabBar.standardAppearance = tabBarAppearance
		tabBar.scrollEdgeAppearance = tabBarAppearance
	}

}
