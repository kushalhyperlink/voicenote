//
//  LoginViewModel.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import Foundation
import SendBirdUIKit
import SendBirdSDK

class LoginViewModel {
    
    private(set) var loginResult = Bindable<Swift.Result<String?, AppError>>()
    
    //MARK:- Class Variable
    
    //MARK:- Init
    init() {
    }
    
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
}

// MARK: Validation Methods
extension LoginViewModel {
    
    /// Validate fields.
    /// - Returns: If any validation error found return error message else nil.
    private func isValidView(userId: String, userName: String) -> AppError? {
        guard !userId.isEmpty else { return AppError.validation(type: .enterUserID) }
        guard !userName.isEmpty else { return AppError.validation(type: .enterUserName) }
        return nil
    }
}

// MARK: Web Services
extension LoginViewModel {
    
    func login(userId: String, userName: String) {
        // Check validation
        if let error = self.isValidView(userId: userId, userName: userName) {
            //Set error data for binding
            self.loginResult.value = .failure(error)
            return
        }
        
        AppLoader.shared.addLoader()
        
        // Set data in sendbird
        SBUGlobals.CurrentUser = SBUUser(userId: userId, nickname: userName)
        SBUMain.connect { [weak self] user, error in
            
            AppLoader.shared.removeLoader()
        
            guard let self = self else { return }
            
            if let error = error {
                self.loginResult.value = .failure(.custom(errorDescription: error.localizedDescription))
                return
            }
            
            if let user = user {
                UserDefaultsConfig.userID = userId
                UserDefaultsConfig.nickName = userName
                
                print("SBUMain.connect: \(user)")
                self.loginResult.value = .success(nil)
            }
        }
    }
}
