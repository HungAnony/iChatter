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
    func onLoadOldMessages(messages : [BaseMessage])
    func onReceiveMessages(messages: [BaseMessage], indexPaths : [IndexPath])
    func onMessageSent(message : BaseMessage)
    func onTypingEvent(event : Int)
    func onError(message : String)
}	

class ChatPresenter: NSObject {
    let firestore = Firestore.firestore()
    let view : ChatView!
    let me : String?
    var oldMessages = Array<BaseMessage>()
    
    
    init(_ view : ChatView){
        self.view = view
        self.me = Auth.auth().currentUser?.uid
    }
    
    
    //MARK: - Send Text Messages
    
    func sendTextMessage(_ text : String?){
        if(text == nil){
            return
        }
        let textMessage = TextMessage()
        textMessage.isHiddenAvatar = true
        textMessage.cellIdentifier = "MeTextCell"
        textMessage.sender = me
        textMessage.timestamp = getCurrentTimestamp()
        textMessage.content = text
        textMessage.type = MessageType.TEXT
        
        FirestoreHelper(firestore).saveMessageToDatabase(
            message: textMessage,
            completion: {
                _ in
                self.view.onMessageSent(message: textMessage)
        },
            fail:{
                _ in
                self.view.onError(message: "Send Text Message Error!")
        })
    }
    
    
    //MARK: - Send Image Messages
    
    func sendImageMessage(_ images : [UIImage]){
        if(images.count == 0){
            return
        }
        let chatImage = ChatImage()
        let imageMessage = ImageMessage()
        
        imageMessage.isHiddenAvatar = true
        imageMessage.cellIdentifier = "MeImageCell"
        imageMessage.sender = me
        imageMessage.timestamp = getCurrentTimestamp()
        imageMessage.type = MessageType.IMAGE
        for image in images{
            chatImage.uuidImage = NSUUID.init().uuidString
            chatImage.localImage = image
            imageMessage.chatImages.append(chatImage)
        }
        
        FirestoreHelper(firestore).uploadFileToStorage(
        message: imageMessage,
        completion : { [unowned self] (imageMessage) in
            self.handleAfterUploaded(imageMessage)
        })
    }

    func handleAfterUploaded(_ message : BaseMessage){
        FirestoreHelper(firestore).saveMessageToDatabase(
            message: message,
            completion: {
                _ in
                self.view.onMessageSent(message: message)
        },
            fail:{
                _ in
                self.view.onError(message: "Send Text Message Error!")
        })
    }
    
    
    
    //MARK: - Receive Messages
    func loadOldMessages(){
        firestore.collection("messages").getDocuments { [unowned self] (query, error) in
            if error != nil {
                print("Download old messages from Database error!")
            }
            else {
                self.oldMessages = self.parseDataFromDocument(query: query)
                self.view.onLoadOldMessages(messages: self.oldMessages)
                self.listenIncomingMessages()
            }
        }
    }
    
    
    func listenIncomingMessages(){
        firestore.collection("messages").addSnapshotListener(includeMetadataChanges: true){ [unowned self] (query, error) in
            if error != nil {
                print("Get new messages from cloud error!")
            }else {
                let newMessagesBeSnapshotted = self.parseDataFromDocument(query: query)
                self.filterMessageFromDatabase(newMessagesBeSnapshotted)
            }
        }
    }
    
    
    func filterMessageFromDatabase(_ newMessages : [BaseMessage]){
        var newMessages = Array<BaseMessage>()
        for newMessage in newMessages{
            for oldMessage in oldMessages{
                if(newMessage.documentId == oldMessage.documentId){
                    print("Old message. Dont append")
                    break
                }
                newMessages.append(newMessage)
            }
        }
        
        var currentIndex = self.oldMessages.count - 1
        var indexPaths = Array<IndexPath>()
        for message in newMessages {
            oldMessages.append(message)
            currentIndex = currentIndex + 1
            let indexPath = IndexPath.init(item: currentIndex, section: 0)
            indexPaths.append(indexPath)
        }
        
        self.view.onReceiveMessages(messages: newMessages,indexPaths : indexPaths)
    }
    
    
    private func parseDataFromDocument(query : QuerySnapshot?) -> [BaseMessage]{
        var messages = Array<BaseMessage>()
        for document in query!.documents{
            let data = document.data()
            let type = data["type"] as! String
            let message = self.parseMessageByType(type,data as NSDictionary)
            message.documentId = document.documentID
            messages.append(message)
        }
        return messages
    }
    
    
    private func parseMessageByType(_ type : String, _ data : NSDictionary) -> BaseMessage{
        switch type {
        case MessageType.TEXT:
            return parseTextMessage(data)
        case MessageType.IMAGE:
            return parseImageMessage(data)
        default :
            return BaseMessage()
        }
    }
    
    
    private func parseTextMessage(_ data : NSDictionary) -> BaseMessage{
        let textMessage = TextMessage()
        let content = data["message"] as! String
        textMessage.content = content
        textMessage.cellIdentifier = "SenderTextCell"
        return textMessage
    }
    
    
    private func parseImageMessage(_ data : NSDictionary) -> BaseMessage{
        let imageMessage = ImageMessage()
        let stringURL = data["url"] as! String
        imageMessage.urlImage = URL(string: stringURL)
        imageMessage.cellIdentifier = "SenderImageCell"
        return imageMessage
    }
    
    
    private func getCurrentTimestamp() -> Double{
        let calendar = Calendar.current
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let result = (hour * 60) + minutes
        return Double(result)
        
    }
}
