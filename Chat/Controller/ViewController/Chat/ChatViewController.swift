//
//  ChatViewController.swift
//  Chat
//
//  Created by Ta Huy Hung on 6/15/20.
//  Copyright © 2020 HungCorporation. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblMessage: UITableView!
    private var presenter : ChatPresenter?
    private var chatModel = ChatModel()
    //    private var heightTabbar : Int = 0
    
    @IBOutlet weak var cstBottomMargin: NSLayoutConstraint!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTextCell") as! SenderTextCell
        //        let data = chatModel
        //        cell.bindData(data)
        return cell
    }
    
    
    @IBAction func onSendPressed(_ sender: Any) {
        //        presenter?.sendMessage(message: chatModel.textSent!)
        presenter?.sendMessage(message: "Test gửi tin nhắn abc 123 bla blo")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ChatPresenter(view: self)
        tblMessage.delegate = self
        tblMessage.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardView()
    }
    
    
    func registerKeyboardView() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    
    func unregisterKeyboardView() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    
    @objc func keyboardWillHide(_ notification:Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        adjustingHeight(true, notification: notification)
    }
    
    
    @objc func keyboardDidShow(_ notification:Notification) {
        print("keyboardDidShow")
    }
    
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    
    func adjustingHeight(_ show:Bool, notification:Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let heightTabbar = self.tabBarController != nil ? self.tabBarController?.tabBar.frame.size.height : 0
        let changeInHeight = (keyboardFrame.size.height - heightTabbar!) * (show ? 1 : 0)
        self.cstBottomMargin?.constant = changeInHeight
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
}

extension ChatViewController : ChatView{
    func onStartingSendMessage(message: String) {
        
    }
    
    func onReceiveMessage(message: String) {
        //        self.chatModel.textSent = message
        //        self.tblMessage.reloadData()
    }
    
    func onMessageSent(message: String) {
        
    }
    
    func onTypingEvent(event: Int) {
        
    }
    
    func onError(message: String) {
        
    }
    
    
}
