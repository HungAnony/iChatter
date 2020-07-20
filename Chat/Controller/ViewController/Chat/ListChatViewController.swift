//
//  ListChatViewController.swift
//  Chat
//
//  Created by Ta Huy Hung on 7/20/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit

class ListChatViewController: BaseViewController {
    let myName : String =  "ListChat"
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let paths = appDelegate.paths
        if(paths.count > 1 && paths[0] == myName){
            // chuyen man hinh
        }
    }
    
    
}
