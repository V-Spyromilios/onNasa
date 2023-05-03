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
		tabBar.items?[0].title = "Perserverance"
		tabBar.items?[1].title = "Curiocity"
		tabBar.items?[2].title = "Opportunity"
		tabBar.items?[3].title = "Spirit"
		
		

//		let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//		let firstVC = storyboard.instantiateViewController(withIdentifier: "mainViewStoryboardID") as! MainViewController
//		let secondVC = storyboard.instantiateViewController(withIdentifier: "mainViewStoryboardID") as! MainViewController
//		let viewControllers = [firstVC, secondVC]
//		setViewControllers(viewControllers, animated: true)
//		UIView.transition(with: self.view,
//						  duration: 2.5,
//						  options: [.curveEaseIn],
//						  animations: nil,
//						  completion: nil)

    }

}

extension TabBarController {
	
}
