//
//  OnboardingStrings.swift
//  OpenTrace
//
//  Created by Robbie Fraser on 14/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation

extension DisplayStrings {

	enum Monitoring {
        
        enum HealthCheck {
            static let title = "Monitoring.HealthCheck.title".localized
            static let subtitle = "Monitoring.HealthCheck.subtitle".localized

            static let feelingWell = "Monitoring.HealthCheck.feelingWell".localized
            static let feelingSick = "Monitoring.HealthCheck.feelingSick".localized
        }

        enum FeelingWell {
            static let title = "Monitoring.FeelingWell.title".localized
            static let subtitle = "Monitoring.FeelingWell.subtitle".localized

            static let okClose = DisplayStrings.General.ok
        }

        enum TrackSymptoms {
            static let title = "Monitoring.TrackSymptoms.title".localized
            static let subtitle = "Monitoring.TrackSymptoms.subtitle".localized
            static let closingStatement = "Monitoring.TrackSymptoms.closingStatement".localized

            static let submit = DisplayStrings.General.submit
            
            enum ErrorIncomplete {
                static let title = "Monitoring.TrackSymptoms.ErrorIncomplete.title".localized
                static let message = "Monitoring.TrackSymptoms.ErrorIncomplete.message".localized
                static let okClose = DisplayStrings.General.ok
            }
        }

        enum Advice {
            static let title = "Monitoring.Advice.title".localized
            static let subtitle = "Monitoring.Advice.subtitle".localized
            static let closingStatement = "Monitoring.Advice.closingStatement".localized

            static let okClose = DisplayStrings.General.ok
        }

        enum ContactForm {
            static let title = "Monitoring.ContactForm.title".localized
            static let subtitle = "Monitoring.ContactForm.subtitle".localized
            static let closingStatement = "Monitoring.ContactForm.closingStatement".localized

            static let submit = DisplayStrings.General.submit
        }

        enum ThanksForInfo {
            static let title = "Monitoring.ThanksForInfo.title".localized
            static let subtitle = "Monitoring.ThanksForInfo.subtitle".localized

            static let okClose = DisplayStrings.General.ok
        }
    }
}
