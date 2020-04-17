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
		setNavbarToBackgroundColour(withShadow: false)
	}

	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		super.pushViewController(viewController, animated: animated)
		viewController.setNavbarToBackgroundColour(withShadow: false)
	}
}

extension UIViewController {

	func setNavbarToBackgroundColour(withShadow: Bool) {
		if #available(iOS 13.0, *) {
			let navBarAppearance = UINavigationBarAppearance()
			navBarAppearance.configureWithDefaultBackground()
			navBarAppearance.backgroundColor = view.backgroundColor
			navBarAppearance.shadowColor = withShadow ? .separator : .clear
			navigationItem.standardAppearance = navBarAppearance
		} else {
			navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
			navigationController?.navigationBar.shadowImage = withShadow ? nil : UIImage()
			navigationController?.navigationBar.isTranslucent = true
		}
	}
}
