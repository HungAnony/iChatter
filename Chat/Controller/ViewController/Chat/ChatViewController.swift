//
//  ChatViewController.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/15/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var presenter : ChatPresenter?
    var totalMessages = Array<BaseMessage>()
    
    var imagesChosen = Array<UIImage>()
    var imagesView = Array<UIImageView>()
    var indexImage = 0
    var isCancelled = false
    var messageType = MessageType.TEXT
    var numberImagesChosen = 0
    
    @IBOutlet weak var cstHeightMessageView: NSLayoutConstraint!
    
    
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var cstBottomMargin: NSLayoutConstraint!
    
    
    @IBOutlet weak var imgChosen1: UIImageView!
    @IBOutlet weak var imgChosen2: UIImageView!
    @IBOutlet weak var imgChosen3: UIImageView!
    @IBOutlet weak var imgChosen4: UIImageView!
    @IBOutlet weak var imgChosen5: UIImageView!
    
    
    @IBAction func cancelImageChosen1(_ sender: Any) {
        cstHeightMessageView.constant = 50
    }
    
    @IBAction func cancelImageChosen2(_ sender: Any) {
        
    }
    
    @IBAction func cancelImageChosen3(_ sender: Any) {
        
    }
    
    @IBAction func cancelImageChosen4(_ sender: Any) {
        
    }
    
    @IBAction func cancelImageChosen5(_ sender: Any) {
        
    }
    
    @IBAction func onSelectGalleryPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Show gallery")
            messageType = MessageType.IMAGE
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cstHeightMessageView.constant = 150
        numberImagesChosen += 1
        print("count times image is selected : \(numberImagesChosen) ")
        
        var selectImageFromPicker : UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            selectImageFromPicker = editedImage
            
        }
        else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage{
            selectImageFromPicker = originalImage
        }
        if let selectedImage = selectImageFromPicker{
            imagesChosen.append(selectedImage)
            indexImage = indexImage + 1
            
            //nếu huỷ ko chọn ảnh thì những ảnh có index lớn hơn cái vừa chọn bị giảm 1
            
        }
        
        for image in imagesChosen{
            imagesView[indexImage - 1].image = image
        }
    }
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
    
    
    @IBAction func onShowCamera(_ sender: Any) {
        
    }
    
    @IBAction func onSendPressed(_ sender: Any) {
        switch messageType {
        case MessageType.TEXT:
            presenter?.sendTextMessage(txtMessage.text)
            break
        
        case MessageType.IMAGE:
            presenter?.sendImageMessage(imagesChosen,numberImagesChosen)
            cstHeightMessageView.constant = 50
            break
            
        default:
            break
        }
        
        txtMessage.text = ""
        txtMessage.endEditing(true)
    }
    
    @IBAction func onDoneTypingGesture(_ sender: Any) {
        txtMessage.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardView()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ChatPresenter(self)
        presenter?.loadOldMessages()
        tblMessage.delegate = self
        tblMessage.dataSource = self
        appendAllImgView()
        cstHeightMessageView.constant = 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalMessages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: totalMessages[indexPath.row].cellIdentifier) as! BaseMessageViewCell
        let data = totalMessages[indexPath.row]
        cell.bindData(data)
        return cell
    }
    
    
    override func adjustingHeight(show: Bool, heightKeyboard: CGFloat, heightTabbar: CGFloat, animationDurarion: TimeInterval) {
        let changeInHeight = (heightKeyboard - heightTabbar) * (show ? 1 : 0)
        self.cstBottomMargin?.constant = changeInHeight
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    
    private func appendAllImgView(){
        imagesView.append(imgChosen1)
        imagesView.append(imgChosen2)
        imagesView.append(imgChosen3)
        imagesView.append(imgChosen4)
        imagesView.append(imgChosen5)
    }
    
}



extension ChatViewController : ChatView{
    func onLoadOldMessages(messages: [BaseMessage]) {
        self.totalMessages = messages
        tblMessage.reloadData()
    }
    
    func onStartingSendMessage(message: String) {
        
    }
    
    func onReceiveMessages(messages: [BaseMessage], indexPaths : [IndexPath]) {
        if(indexPaths.count == 0){
            return
        }
        self.totalMessages = messages
        tblMessage.scrollToRow(at: indexPaths.last!, at: .bottom, animated: true)
    }
    
    func onMessageSent(message: BaseMessage) {
        totalMessages.append(message)
        let currentIndex = totalMessages.count - 1
        let indexPath = IndexPath.init(item: currentIndex, section: 0)
        var indexPaths = Array<IndexPath>()
        indexPaths.append(indexPath)
        tblMessage.insertRows(at: indexPaths, with: .fade)
    }
    
    func onTypingEvent(event: Int) {
        
    }
    
    func onError(message: String) {
        
    }
    
    
}
