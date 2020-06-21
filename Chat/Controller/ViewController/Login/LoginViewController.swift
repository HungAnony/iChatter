//
//  ViewController.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/8/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, LoginView{
    var presenter : LoginPresenter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LoginPresenter(view : self)
        registerNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func onRegisterPressed(_ sender: Any) {
        //C1 : dùng segue
        performSegue(withIdentifier: "segueShowRegisterView", sender: nil)
        
        //C2 : tạo viewController thông qua id rồi push vào navigationController => tương đương sequ
//        let registerVC = LoginStoryboard.init().getViewControllerByIdentifier(identifier: "RegisterAccountController")
//        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }
    
    
    
    func onLoginSucceed(message : String) {
        print(message)
        goToChatView()
    }
    
    func onLoginFailed(message : String) {
        print(message)
    }
    
    func onShowSpinner() {
        self.showSpinner(onView: self.view)
    }
    
    func onRemoveSpinner(){
        self.removeSpinner()
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
    
    func goToChatView(){
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        sceneDelegate.setUpRootViewController()
    }
    
    private func registerNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector:#selector(onReceviedNotification(_:)), name: NSNotification.Name.init(rawValue: Channel.REGISTER), object: nil)
    }
    
    @objc func onReceviedNotification(_ notification : Notification)  {
        let data = notification.object! as! String
        print("Login view recevied \(data)")
    }
    
}

