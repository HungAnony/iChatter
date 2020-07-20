//
//  BaseMessage.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/21/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import Foundation


class BaseMessage{ 
    var sender : String!
    var timestamp : Double!
    var documentId : String!
    var isHiddenAvatar : Bool!
    var cellIdentifier : String!
    var indexMessage : Int!
    var type = MessageType.DEFAULT
}








