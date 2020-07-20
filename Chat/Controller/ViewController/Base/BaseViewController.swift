//
//  BaseViewController.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/24/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class BaseViewController: UIViewController {

    var titleNav : String? {
        return nil
    }
    
    var vSpinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = titleNav{
            self.title = title
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white // for all text on Navigation Bar
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white // Only for title
        ]
    }
    
    func allowToShowBannerNotification() -> Bool{
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(allowToShowBannerNotification()){
            registerRemotePushNotification()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterRemotePushNotification()
    }
    
    private func registerRemotePushNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(onRemotePushNotificationReceived(_:)), name: NSNotification.Name.init(rawValue: Channel.REMOTE_PUSH), object: nil)
    }
    
    
    private func unRegisterRemotePushNotification(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: Channel.REMOTE_PUSH), object:  nil)
    }
    
    @objc private func onRemotePushNotificationReceived(_ notification : Notification){
        let banner = NotificationBanner(title: "local", subtitle: "subtitle", style: .success)
        banner.show(on : self)
    }
    
    func showSpinner(onView : UIView){
        //        let width = onView.bounds.width/3
        //        let height = onView.bounds.height/6
        //        let frame = CGRect(x: onView.bounds.midX - width/2, y: onView.bounds.midY - height/2, width: width , height: height)
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    
    func removeSpinner(){
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    
    func postNotificationCenter(channel : String, data : Any?) {
        var notification : Notification = Notification(name: Notification.Name.init(rawValue: channel))
        notification.object = data
        NotificationCenter.default.post(notification)
    }
    
    func registerKeyboardView() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    
    func unregisterKeyboardView() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    
    @objc func keyboardWillHide(_ notification:Notification) {
        onEventKeyboardChangeHeight(false, notification, 0)
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        onEventKeyboardChangeHeight(true, notification, 0)
    }
    
    
    @objc func keyboardDidShow(_ notification:Notification) {
        print("keyboardDidShow")
    }
    
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        onEventKeyboardChangeHeight(false, notification, 0)
    }
    
    
    func onEventKeyboardChangeHeight(_ state : Bool,_ notification : Notification, _ heightTabbar : CGFloat){
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        adjustingHeight(show: state, heightKeyboard : keyboardFrame.size.height,heightTabbar : heightTabbar, animationDurarion: animationDurarion)
    }
    
    @objc func adjustingHeight(show: Bool, heightKeyboard :CGFloat ,heightTabbar : CGFloat, animationDurarion: TimeInterval){
        
    }
    
    
}
