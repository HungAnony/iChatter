//
//  SenderImageCell.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/19/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class SenderImageCell: BaseMessageViewCell {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblNickname: UILabel!
    @IBOutlet weak var imgMessage: UIImageView!
    
    override func bindData(_ message: BaseMessage) {
        let imageMessage = message as! ImageMessage
        imgMessage.sd_setImage(with: imageMessage.urlImage, placeholderImage: UIImage(named: "placeholder"))
    }
}


