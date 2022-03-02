//
//  Bindable.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    private lazy var observer: ((T?) -> ())? = nil
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
