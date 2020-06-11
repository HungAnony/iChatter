//
//  ViewController.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/8/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginView{
    var presenter : LoginPresenter?
    
    override func viewDidLoad() {
        presenter = LoginPresenter(view : self)
    }
    
    func onLoginSucceed(message : String) {
        print(message)
    }
    
    func onLoginFailed(message : String) {
        print(message)
    }
    
    func onShowSpinner() {
        
    }
    
    @IBAction func onGoogleLogin(_ sender: Any) {
        presenter?.requestGoogleLogin()
    }
    
    @IBAction func onFacebookLogin(_ sender: Any) {
        presenter?.requestFacebookLogin()
    }
    
    @IBAction func onAppleLogin(_ sender: Any) {
        presenter?.requestAppleLogin()
    }
    
}

