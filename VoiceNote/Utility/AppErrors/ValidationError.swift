//
//  ValidationError.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import Foundation

extension AppError.Enums {
    enum ValidationError {
        case enterUserID
        case enterUserName
        case custom(errorDescription: String?)
    }
}

extension AppError.Enums.ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .enterUserID: return "Please enter user id"
        case .enterUserName: return "Please enter user name"
        case .custom(let errorDescription): return errorDescription
        }
    }
}
