//
//  LoginVC.swift
//  VoiceNote
//
//  Created by Hyperlink on 01/03/22.
//

import UIKit
import SendBirdUIKit

class LoginVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var txtUserName: ThemeTextField!
    @IBOutlet weak var txtUserId: ThemeTextField!
    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    private let viewModel = LoginViewModel()
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
    }
    
    /**
     Setup all view model observer and handel data and erros.
     */
    private func setupViewModelObserver() {
        // Login result observer
        self.viewModel.loginResult.bind(observer: { (result) in
            switch result {
            case .success(_):
                // Redirect to next screen or home screen
                UIApplication.shared.setHome()
                
            case .failure(let error):
                Alert.shared.showAlert(message: error.errorDescription ?? "", completion: nil)
                
            case .none: break
            }
        })
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func onSignIn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewModel.login(userId: self.txtUserId.text!, userName: self.txtUserName.text!)
    }
    
    //------------------------------------------------------
}
