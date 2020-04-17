//
//  UploadDataStrings.swift
//  OpenTrace
//
//  Created by Neil Horton on 17/04/2020.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation

extension DisplayStrings {

    enum UploadData {
        
        enum Info {
            static let title = "UploadData.Info.title".localized
            static let subHeading = "UploadData.Info.subHeading".localized
            static let primaryCTA = "UploadData.Info.primary_cta".localized
        }
        
        enum EnterPin {
            static let title = "UploadData.EnterPin.title".localized
            static let subHeading = "UploadData.EnterPin.subHeading".localized
            static let primaryCTA = "UploadData.EnterPin.primary_cta".localized
            static let disclaimer = "UploadData.EnterPin.disclaimer".localized
            static let invalidPin = "UploadData.EnterPin.invalid_pin".localized
        }
        
        enum UploadSuccess {
            static let title = "UploadData.UploadSuccess.title".localized
            static let subHeading = "UploadData.UploadSuccess.subHeading".localized
            static let primaryCTA = "UploadData.UploadSuccess.primary_cta".localized
        }
    }
}
