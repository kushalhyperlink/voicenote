//
//  UIView+Extension.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit

extension UIView {
    public class func fromNib<T: UIView>() -> T {
        let name = String(describing: Self.self);
        guard let nib = Bundle(for: Self.self).loadNibNamed(
            name, owner: nil, options: nil)
        else {
            fatalError("Missing nib-file named: \(name)")
        }
        return nib.first as! T
    }
}
