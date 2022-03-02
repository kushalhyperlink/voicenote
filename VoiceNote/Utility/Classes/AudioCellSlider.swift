//
//  AudioCellSlider.swift
//  VoiceNote
//
//  Created by Hyperlink on 02/03/22.
//

import UIKit

class AudioCellSlider: UISlider {
    
    //MARK:- Class Variables
    
    var thumbRadius: CGFloat = 12
    var trackHeight: CGFloat = 2.5
    
    var thumbColor: UIColor = .blue {
        didSet {
            self.setThumbImage()
        }
    }
    
    lazy var thumbView: UIImageView = {
        let thumb = UIImageView()
        return thumb
    }()
    
    //------------------------------------------------------
    
    //MARK:- Init
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    //------------------------------------------------------
    
    //MARK:- LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //------------------------------------------------------
    
    //MARK:- Override functions
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
    //------------------------------------------------------
    
    //MARK:- Other functions
    
    private func initCommon() {
        self.setThumbImage()
    }
    
    private func setThumbImage() {
        let thumb = thumbImage(radius: thumbRadius)
        setThumbImage(thumb, for: .normal)
        setThumbImage(thumb, for: .highlighted)
    }
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        thumbView.backgroundColor = thumbColor
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    //------------------------------------------------------
}
