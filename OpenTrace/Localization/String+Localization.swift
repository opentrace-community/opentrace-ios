//
//  String+Localization.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 14/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation

final class ClassForLocalizableStrings {}

var bundleForStringLocalization: Bundle = Bundle(for: ClassForLocalizableStrings.self)

extension String {

	var localized: String {
		return NSLocalizedString(self, bundle: bundleForStringLocalization, comment: self)
	}

	func localizedFormat(_ arguments: CVarArg...) -> String {
		return String(format: localized, arguments: arguments)
	}
}

extension RawRepresentable where RawValue == String {
	var localized: String {
		return self.rawValue.localized
	}
}
