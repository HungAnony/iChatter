//
//  FirestoreHelper.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/21/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class FirestoreHelper{
    private var firestoreHelper : Firestore!
    private let lock = NSLock()
    
    
    init(_ firestore : Firestore){
        self.firestoreHelper = firestore
    }
    
    func saveMessageToDatabase(message : BaseMessage,
                               completion : @escaping (_ message : BaseMessage) -> Void,
                               fail : @escaping (_ messageError : String) -> Void){
        var ref: DocumentReference? = nil
        ref = firestoreHelper.collection("messages").addDocument(data: getData(message) as! [String : Any]) { err in
            if let err = err {
                fail("Error adding document: \(err)")
            } else {
                print("Document 1 added with ID: \(ref!.documentID)")
                message.documentId = ref!.documentID
                completion(message)
            }
        }
    }
    
    private func getData(_ message : BaseMessage) -> NSDictionary{
        var content : String?
        var url : String?
        switch message.type {
        case "TEXT":
            content = (message as! TextMessage).content
            url = ""
            break
        case "IMAGE":
            content = ""
            url = (message as! ImageMessage).urlImage.absoluteString
            break
        default:
            content = "UNDEFINED"
            url = "UNDEFINED"
        }
        let data = ["sender" : message.sender!,
                    "message" : content!,
                    "url" : url!,
                    "timestamp" : message.timestamp!,
                    "type": message.type] as [String : Any]
        
        return data as NSDictionary
    }
    
    
    func uploadFileToStorage(message : ImageMessage,
                             completion : @escaping (_ message : BaseMessage)-> Void){
        
        for chatImage in message.chatImages{
            let storageMetadata = StorageMetadata(dictionary: ["uuidImage":"\(chatImage.uuidImage!)"])
            let storageRef = Storage.storage().reference().child("Image messages").child("uuidImage : \(chatImage.uuidImage!)")
            
            if let dataWillBeUploaded = chatImage.localImage.jpegData(compressionQuality: 1) {
                storageRef.putData(dataWillBeUploaded, metadata: storageMetadata, completion: {
                    (metadata,error) in
                    
                    if(error != nil){
                        print("Failed to uploaded images with error: \(error!)")
                        self.handleUploadViaLock(message, completion, metadata!, storageRef, error)
                        return
                    }
                    
                    print("Upload images to Storage successfully!!")
                    self.setURLImage(storageRef, message) { (message) in
                        self.handleUploadViaLock(message, completion, metadata!, storageRef)
                    }
                    
                })
            }
            
        }
    }
    
    private func setURLImage(_ storageRef : StorageReference,
                             _ imageMessage : ImageMessage,
                             completion : @escaping (_ message : ImageMessage) -> Void){
        storageRef.downloadURL(completion: { (url, error) in
            if error != nil {
                print("Failed to download url:", error!)
                return
            } else {
                imageMessage.urlImage = url
                print("url image: \(imageMessage.urlImage!)")
                completion(imageMessage)
            }
        })
    }
    
    private func handleUploadViaLock(_ message : ImageMessage,
                                   _ completion : @escaping (_ message : BaseMessage) -> Void,
                                   _ metadata: StorageMetadata,
                                   _ storageRef : StorageReference,
                                   _ error : Error? = nil){
        lock.lock()
        let uuidImage = metadata.dictionaryRepresentation()["name"] as! String
        var uploaded = 0
        for chatImage in message.chatImages {
            if uuidImage.contains(chatImage.uuidImage){
                if (error != nil) {
                    chatImage.state = ChatImage.State.UPLOADFAILED
                }
                else {
                    chatImage.state = ChatImage.State.UPLOADED
                }
            }
            if (chatImage.state != ChatImage.State.NOT_UPLOADED) {
                uploaded += 1
            }
        }
        
        if (uploaded == message.chatImages.count) {
            lock.unlock()
            completion(message)
        }
        else{
            lock.unlock()
        }
        
    }
    
    
    
    
}
