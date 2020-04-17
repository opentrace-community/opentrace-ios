//
//  TransparentNavController.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 15/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

final class TransparentNavController: UINavigationController {

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setTransparentNavBar()
	}

	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		super.pushViewController(viewController, animated: animated)
		viewController.setTransparentNavBar()
	}
}

extension UIViewController {

	func setTransparentNavBar() {
		if #available(iOS 13.0, *) {
			let navBarAppearance = UINavigationBarAppearance()
			navBarAppearance.configureWithTransparentBackground()
			navBarAppearance.shadowColor = .clear
			navigationItem.standardAppearance = navBarAppearance
		} else {
			navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
			navigationController?.navigationBar.shadowImage = UIImage()
			navigationController?.navigationBar.isTranslucent = true
		}
	}
}
