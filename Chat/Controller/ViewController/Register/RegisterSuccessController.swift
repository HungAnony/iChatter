//
//  RegisterSuccessController.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/15/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit

class RegisterSuccessController: BaseViewController {

    @IBOutlet weak var txtShowInfo: UILabel!
    var name : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtShowInfo.text = "Chúc mừng \(name) đã đăng kí tài khoản thành công !"
    }

    @IBAction func onCompletePressed(_ sender: Any) {
        self.postNotificationCenter(channel: Channel.REGISTER, data: name)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}
