//
//  MeTextCell.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/19/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit

class MeTextCell: BaseMessageViewCell {
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTimestamp: UILabel!
    
    override func bindData(_ message : BaseMessage){
        let textMessage = message as! TextMessage
        lblContent.text = textMessage.content
        lblTimestamp.text = String.formatTime(time: textMessage.timestamp)
    }
    
    
}
