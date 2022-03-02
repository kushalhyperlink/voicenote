//
//  AppLoader.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit

class AppLoader {
    
    //MARK: Shared Instance
    static let shared: AppLoader = AppLoader()
    
    //MARK: Class Variables
    private let container: UIView = UIView()
  
    
    //MARK: Class Funcation
    
    /**
     Add app loader
     */
    func addLoader() {
        removeLoader()
        container.frame = UIScreen.main.bounds
        container.backgroundColor = .clear
        
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityView.color = .black
        activityView.center = self.container.center
        
        container.addSubview(activityView)
        UIApplication.shared.windows.first?.addSubview(container)
        activityView.startAnimating()

    }
    
    /**
     Remove app loader
     */
    func removeLoader() {
        container.removeFromSuperview()
    }
}
