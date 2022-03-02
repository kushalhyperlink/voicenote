//
//  UIStoryBoard+Extension.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit

extension UIStoryboard {
    
    //App bundle
    private static var bundle: Bundle {
        return Bundle.main
    }
    
    /**
     Authentication storyboard
     */
    static var auth: UIStoryboard {
        return UIStoryboard(name: "Authentication", bundle: bundle)
    }
    
    
    /**
     Instantiate View Controller from selected storyboard
     - Returns: View Controller
     - Parameter name: Instantiate View Controller Name
     */
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = self.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
}
