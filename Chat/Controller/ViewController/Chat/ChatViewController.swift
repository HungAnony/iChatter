//
//  ChatViewController.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/15/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    @IBOutlet weak var cstHeightMessageView: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewGallery: UICollectionView!
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var cstBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var notifyNewMessageView: UIView!
    
    var presenter : ChatPresenter?
    var totalMessages = Array<BaseMessage>()
    var imagesChosen = Array<UIImage>()
    var messageType = MessageType.TEXT
    var imageCellDelegate : ImageCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cstHeightMessageView.constant = 50
        presenter = ChatPresenter(self)
        presenter?.loadOldMessages()
        handleNewMessageViewAppear(view: notifyNewMessageView, alpha: 0)
        tblMessage.delegate = self
        tblMessage.dataSource = self
        collectionViewGallery.delegate = self
        collectionViewGallery.dataSource = self
        registerPushTokenReceiver()
        registerForPushNotifications()
    }
    
    deinit {
        unRegisterPushTokenReceiver()
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                granted, error in
                print("Permission granted: \(granted)") // 3
                DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
                }
        }
    }
    
    private func registerPushTokenReceiver(){
        NotificationCenter.default.addObserver(self, selector: #selector(onPushTokenReceived(_:)), name: NSNotification.Name.init(rawValue: Channel.PUSH_TOKEN), object: nil)
    }
    
    private func unRegisterPushTokenReceiver(){
//        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: Channel.PUSH_TOKEN), object: nil)
    }
    
    //Device Token: 91b9ea53029c12bbd4ac0bee86da3c508aa5aa7f467ade9eac19a2753094c3ee
    @objc private func onPushTokenReceived(_ notification : Notification){
        let deviceToken = notification.object as! String
        print(deviceToken)
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
    
    
    @IBAction func onShowCamera(_ sender: Any) {
        
    }
    
    
    @IBAction func onSendPressed(_ sender: Any) {
        switch messageType {
        case MessageType.TEXT:
            presenter?.sendTextMessage(txtMessage.text)
            break
            
        case MessageType.IMAGE:
            presenter?.sendImageMessage(imagesChosen)
            imagesChosen.removeAll()
            cstHeightMessageView.constant = 50
            break
            
        default:
            break
        }
        
        txtMessage.text = ""
        txtMessage.endEditing(true)
    }
    
    @IBAction func onTextingMessage(_ sender: Any) {
        messageType = MessageType.TEXT
    }
    
    
    @objc override func adjustingHeight(show: Bool, heightKeyboard: CGFloat, heightTabbar: CGFloat, animationDurarion: TimeInterval) {
        let changeInHeight = (heightKeyboard - heightTabbar) * (show ? 1 : 0)
        self.cstBottomMargin?.constant = changeInHeight
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}


//MARK: - Handle Gesture & Size Of Elements
extension ChatViewController{
    @IBAction func mainScreenTapped(_ sender: Any) {
        txtMessage.endEditing(true)
    }
    
    @IBAction func NewMessageCommingTapped(_ sender: Any) {
        handleNewMessageViewAppear(view: notifyNewMessageView, alpha: 0)
        scrollToLastRow()
    }
    
    private func handleNewMessageViewAppear(view : UIView,alpha : CGFloat){
        view.alpha = alpha
        view.layer.cornerRadius = 0.2
    }
    
    private func scrollToLastRow(){
        let lastMessageRow = totalMessages.count - 1
        if(lastMessageRow < 0){
            return
        }
        tblMessage.scrollToRow(at: IndexPath(row: lastMessageRow, section: 0), at: .bottom, animated: true)
    }
    
    
}

//MARK: - Register Keyboard View
extension ChatViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardView()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardView()
    }
    
}

//MARK: - Select gallery & choose image
extension ChatViewController : UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ImageCellDelegate{
    
    
    func delete(cell: ImageGalleryCell) {
        if let indexPath = collectionViewGallery.indexPath(for: cell){
            imagesChosen.remove(at: indexPath.item)
            collectionViewGallery.deleteItems(at: [indexPath])
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesChosen.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGalleryCell", for: indexPath) as! ImageGalleryCell
        let currentImage = imagesChosen[indexPath.item]
        cell.setImage(image: currentImage)
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt \(indexPath)")
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
        var selectImageFromPicker : UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            selectImageFromPicker = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage{
            selectImageFromPicker = originalImage
        }
        
        if let selectedImage = selectImageFromPicker{
            imagesChosen.append(selectedImage)
            collectionViewGallery.reloadData()
        }
        
    }
}




//MARK: - Handle callback from Presenter
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
        tblMessage.scrollToRow(at: IndexPath(row: totalMessages.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    func onMessageSent(message: BaseMessage) {
        totalMessages.append(message)
        let currentIndex = totalMessages.count - 1
        let indexPath = IndexPath.init(item: currentIndex, section: 0)
        var indexPaths = Array<IndexPath>()
        indexPaths.append(indexPath)
        tblMessage.insertRows(at: indexPaths, with: .fade)
        handleNewMessageViewAppear(view: notifyNewMessageView, alpha: 1)
    }
    
    func onTypingEvent(event: Int) {
        
    }
    
    func onError(message: String) {
        
    }
    
    
}
