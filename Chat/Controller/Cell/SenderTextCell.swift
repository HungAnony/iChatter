//
//  MessageCell.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/19/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit

class SenderTextCell: UITableViewCell {
    @IBOutlet weak var lblTextMessage: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblNickname: UILabel!
    
    func bindData(_ chatModel : ChatModel){
        lblTextMessage.text = chatModel.textSent
        imgAvatar.image = UIImage(named: chatModel.imageAvatar!)
        lblNickname.text = chatModel.nickName
    }
    
    
}
