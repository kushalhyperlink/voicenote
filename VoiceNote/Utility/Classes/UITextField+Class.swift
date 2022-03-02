//
//  UITextField+Class.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit
import SendBirdUIKit

class ThemeTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 5, left: 13, bottom: 5, right: 13)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = SBUFontSet.body1
        self.borderStyle = .none
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.addTarget(self, action: #selector(self.textFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
        self.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + padding.left ,
            y: bounds.origin.y + padding.top,
            width: bounds.size.width - (padding.left + padding.right),
            height: bounds.size.height - (padding.top + padding.bottom)
        )
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    @objc private func textFieldDidBeginEditing(_ textField: UITextField) {
        self.layer.borderColor = UIColor.themePinkishOrange.cgColor
    }
    
    @objc private func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
}
