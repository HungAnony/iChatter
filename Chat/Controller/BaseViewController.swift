//
//  BaseViewController.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/12/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController{
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

    
    
}
