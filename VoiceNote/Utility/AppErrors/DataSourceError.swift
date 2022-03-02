//
//  DataSourceError.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import Foundation

//MARK: DataSourceError

extension AppError.Enums {
    enum DataSourceError {
        case noDataFound
        case custom(errorDescription: String?)
    }
}

extension AppError.Enums.DataSourceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noDataFound: return "No data found"
        case .custom(let errorDescription): return errorDescription
        }
    }
}
