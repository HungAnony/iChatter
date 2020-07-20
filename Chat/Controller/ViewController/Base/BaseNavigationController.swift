//
//  BaseNavigationController.swift
//  Chat
//
//  Created by Ta Huy Hung on 7/20/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerRemotePushNotification()
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
        let userInfo = notification.object as! Dictionary<String, Any>
        if let aps = userInfo["aps"] as? [String:AnyObject] {
            let alert = aps["alert"] as? String
            let banner = NotificationBanner(title: "local", subtitle: alert, style: .success)
            banner.show(on : self)
        }
        
    }
    

}
