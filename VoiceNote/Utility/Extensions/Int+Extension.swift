//
//  Int+Extension.swift
//  VoiceNote
//
//  Created by Hyperlink on 02/03/22.
//

import Foundation

extension Int {
    func toTimeFormatted() -> String {
        let seconds: Int = self % 60
        let minutes: Int = (self / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
