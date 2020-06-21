//
//  ChatPresenter.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/19/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit
import Firebase

protocol ChatView{
    func onStartingSendMessage(message : String)
    func onReceiveMessage(message : String)
    func onMessageSent(message : String)
    func onTypingEvent(event : Int)
    func onError(message : String)
}

class ChatPresenter: NSObject {
    private var view : ChatView!
    private var firestore : Firestore!
    private var chatModel : ChatModel? = nil
    
    
    init(view : ChatView){
        super.init()
        self.view = view
        self.firestore = Firestore.firestore()
//        self.chatModel = ChatModel(imageAvatar: "avatar1", nickName: "Hung", textSent: "Mình bắt chiếc loài mèo kêu nha kêu cùng anh méo méo méo méo", imageSent: nil)
    }
    
    func sendMessage(message : String) {
        var ref: DocumentReference? = nil
        ref = firestore.collection("messages").addDocument(data: [
            "first": "Hung",
            "last": "Anony",
            "born": 1998,
            "message": message
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func readMessages() {
        firestore.collection("messages").getDocuments { (query, error) in
            if error != nil {
                print("Reading error")
            }else {
                for document in query!.documents {
                    let data = document.data()
                    print(data["first"] as! String)
                }
            }
        }
    }
    
    private func listenIncomingMessage() {
        print("I'm listening new message")
        firestore.collection("messages").addSnapshotListener(includeMetadataChanges: true) { (query, error) in
            for document in query!.documents {
                let data = document.data()
                print(data["message"] as! String)
            }
        }
    }
    
}
