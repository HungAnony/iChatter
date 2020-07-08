//
//  MeImageCell.swift
//  Chat
//
//  Created by Ta Huy Hung on 5/19/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MeImageCell: BaseMessageViewCell {
    private let firestore = Firestore.firestore()
    @IBOutlet weak var imgMessage: UIImageView!
    @IBOutlet weak var lblTimestamp: UILabel!
    
    override func bindData(_ message: BaseMessage) {
        let imageMessage = message as! ImageMessage
        lblTimestamp.text = String.formatTime(time: imageMessage.timestamp)
        imgMessage.image = FirestoreHelper(firestore).downloadImage(message)
    }
}
