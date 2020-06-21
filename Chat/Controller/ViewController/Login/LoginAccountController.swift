//
//  LoginAccountController.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/12/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit
class LoginAccountController: BaseViewController{
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override var titleNav : String? {
        return "Login"
    }
    
    let chatVC = ChatViewController()
    
    
    @IBAction func onLoginPressed(_ sender: Any) {
//        saveUserInfo(username: txtUsername.text, password: txtPassword.text)
        checkUserLogin()
        self.navigationController?.popToViewController(chatVC, animated: true)
    }
    
    func checkUserLogin(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
//
}
