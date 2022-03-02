//
//  UIApplication+Extension.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit
import SendBirdSDK
import SendBirdUIKit

extension UIApplication {
    /**
     Sets home screen
     */
    func setHome() {
        let mainVC = ChannelListVC()
        let naviVC = UINavigationController(rootViewController: mainVC)
        naviVC.modalPresentationStyle = .fullScreen
        self.setRootController(for: naviVC)
    }
    
    /**
     Sets login screen
     */
    func setLogin() {
        if let loginNavigation = UIStoryboard.auth.instantiateViewController(withIdentifier: "NavLogin") as? UINavigationController {
            self.setRootController(for: loginNavigation)
        }
    }
    
    /// Logout user from app and clear all user data from user default
    func logoutAppUser() {
        SBUMain.disconnect {
            print("SBUMain.disconnect")
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
            UserDefaults.standard.synchronize()
            UIApplication.shared.setLogin()
        }
    }
    
    private func setRootController(for rootController: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            // Set the new rootViewController of the window.
            
            window.rootViewController = rootController
            window.makeKeyAndVisible()
            
            // A mask of options indicating how you want to perform the animations.
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            
            // The duration of the transition animation, measured in seconds.
            let duration: TimeInterval = 0.3
            
            // Creates a transition animation.
            // Though `animations` is optional, the documentation tells us that it must not be nil. ¯\_(ツ)_/¯
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: { completed in
                // Do something on completion here
            })
        }
    }
    
    /**
     Manage user redirection after login, logout and signup
     */
    func manageLogin() {
        if let userID = UserDefaultsConfig.userID,
           !userID.isEmpty,
           let userName = UserDefaultsConfig.nickName,
           !userName.isEmpty {
            
            AppLoader.shared.addLoader()
            
            // Set data in sendbird
            SBUGlobals.CurrentUser = SBUUser(userId: userID, nickname: userName)
            SBUMain.connect { [weak self] user, error in
                
                AppLoader.shared.removeLoader()
                
                if user != nil {
                    self?.setHome()
                } else {
                    self?.setLogin()
                }
            }
        } else {
            self.setLogin()
        }
    }
    
    /// To get top of the view controller
    /// - Parameter controller: Any controller which is need to find top view controller
    /// - Returns: Optional top view controller
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}
