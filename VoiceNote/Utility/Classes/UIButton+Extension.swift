//
//  UIButton+Extension.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit

class ThemeLightBlue: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = .systemFont(ofSize: 20)
        self.backgroundColor = .themePinkishOrange
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
    }
}
