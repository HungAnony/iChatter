//
//  RegisterAccountController.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/12/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit
class RegisterAccountController: BaseViewController{
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRetypePassword: UITextField!
    
    var userInfo = ["user" : "" , "pass" : "" , "retypePass" : ""]
    var id = 0
    
    override var titleNav : String? {
        return "Register"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func onRegisterPressed(_ sender: Any) {
        checkUserRegister()
    }
    
    
    private func checkUserRegister(){
        if(txtPassword.text != txtRetypePassword.text){
            txtRetypePassword.text = "Password nhập chưa trùng nhau!"
            txtRetypePassword.textColor = UIColor.red
            return
        }
        saveUserData()
    }
    
    func saveUserData(){
        while (UserDefaults.standard.dictionary(forKey: "UserInfo + \(id)") != nil) {
            id += 1
            clearUserData()
        }
        if txtUsername.text == nil || txtPassword.text == nil || txtRetypePassword.text == nil{
            setData("","","")
        }
        else{
            setData(txtUsername.text!,txtPassword.text!,txtRetypePassword.text!)
            UserDefaults.standard.set(userInfo, forKey: "UserInfo + \(id)")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func setData(_ username : String,_ password : String,_ retypePassword : String){
        userInfo["user"] = username
        userInfo["pass"] = password
        userInfo["retypePass"] = retypePassword
        
    }
    
    
    
    private func clearUserData(){
        UserDefaults.standard.removeObject(forKey: "UserInfo")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRegisterSucceed"{
            let destVC = segue.destination as! RegisterSuccessController
            destVC.name = txtUsername.text ?? ""
        }
    }
    
}
