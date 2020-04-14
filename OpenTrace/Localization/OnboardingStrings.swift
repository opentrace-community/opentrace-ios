//
//  OnboardingStrings.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 14/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation


extension DisplayStrings {

	enum Onboarding {

		static func enterOTPSent(mobileNumber: String) -> String {
			return "Onboarding.EnterOTPSent".localizedFormat(mobileNumber)
		}

		static let wrongNumber = "Onboarding.WrongNumber".localized

		static let resendCode = "Onboarding.ResendCode".localized

		static let invalidOTP = "Onboarding.InvalidOTP".localized

		static let wrongOTP = "Onboarding.WrongOTP".localized

		static func codeWillExpire(time: String) -> String {
			return "Onboarding.CodeWillExpire".localizedFormat(time)
		}

		static let codeHasExpired = "Onboarding.CodeHasExpired".localized

		enum Intro {
			static let header = "Onboarding.Intro.header".localized
			static let primaryBody = "Onboarding.Intro.primaryBody".localized
			static let secondaryBody = "Onboarding.Intro.secondaryBody".localized
			static let footerButtonTitle = "Onboarding.Intro.footerButtonTitle".localized
		}
	}
}
