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
    private var url : URL?
    private let group = DispatchGroup()
    private let semaphore = DispatchSemaphore(value: 1)
    
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
        var propertyMess : Any?
        switch message.type {
        case "TEXT":
            propertyMess = (message as! TextMessage).content
            break
        case "IMAGE":
            propertyMess = (message as! ImageMessage).urlImage
            break
        default:
            propertyMess = "UNDEFINED CONTENT MESSAGE"
        }
        let data = ["sender" : message.sender!,
                    "message" : propertyMess!,
                    "timestamp" : message.timestamp!,
                    "type": message.type] as [String : Any]
        
        return data as NSDictionary
    }
    
    
    func uploadFileToStorage(_ imageMessage : ImageMessage, _ images : [UIImage]){
        let uuidImage = NSUUID.init().uuidString
        let storageRef = Storage.storage().reference().child("Image messages").child("uuidImage : \(uuidImage)")
        group.enter()
        for image in images{
            if let dataWillBeUploaded = image.jpegData(compressionQuality: 1) {
                storageRef.putData(dataWillBeUploaded, metadata: nil, completion: { [unowned self]
                    (metadata,error) in
                    if(error != nil){
                        print("Failed to uploaded images with error: \(error!)")
                        return
                    }
                    print("Upload images to Firebase Storage successfully!!")
                    self.setURLImage(storageRef,imageMessage)
                    self.group.leave()
                })
            }
        }
    }
    
    private func setURLImage(_ storageRef : StorageReference,_ imageMessage : ImageMessage){
        group.enter()
        storageRef.downloadURL(completion: { (url, error) in
            if error != nil {
                print("Failed to download url:", error!)
                return
            } else {
                imageMessage.urlImage = url
                print("url image: \(imageMessage.urlImage!)")
                self.group.leave()
            }
        })
    }
    
    func downloadImage(_ message : BaseMessage) -> UIImage{
        let imageView = UIImageView()
        imageView.sd_setImage(with: (message as! ImageMessage).urlImage)
        return imageView.image!
    }
    
}
