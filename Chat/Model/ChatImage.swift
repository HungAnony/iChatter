//
//  ChatImage.swift
//  Chat
//
//  Created by Ta Huy Hung on 7/9/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit

class ChatImage{
    enum State{
        case NOT_UPLOADED
        case UPLOADING
        case UPLOADED
        case UPLOADFAILED
    }
    var localImage : UIImage!
    var uuidImage : String!
    var state : State! = State.NOT_UPLOADED
}


