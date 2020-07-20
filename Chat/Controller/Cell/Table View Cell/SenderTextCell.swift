//
//  MessageCell.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/19/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit

class SenderTextCell: BaseMessageViewCell {
    @IBOutlet weak var lblTextMessage: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblNickname: UILabel!
    
    override func bindData(_ message : BaseMessage){
        let textMessage = message as! TextMessage
        lblTextMessage.text = textMessage.content
    }
    
    
}
