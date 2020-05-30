//
//  ChatViewController.swift
//  IosOnlineDating
//
//  Created by 姜宏昀 on 2020/5/24.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import UIKit
import Firebase
import Photos
import FirebaseStorage
import JSQMessagesViewController



class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    
    
    var friend:User? = nil
    var db = Firestore.firestore()
    var messages = [JSQMessage]()
    var messageRef:CollectionReference? = nil
    var pairRef:CollectionReference? = nil
    var __THIS__:THIS!
    var typingListener:ListenerRegistration? = nil
    var messageListener:ListenerRegistration? = nil
//    var alreadyCreateListener:Bool = false
    
    
    var lastMessage:String = ""
    var lastMessageDate:Date? = nil
    
    var left:Bool = false
    
    
    
    //            isTyping
    private lazy var userIsTypingRef: DocumentReference = (pairRef?.document(__THIS__.Uid))! // 1
    private var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingRef.setData([
                "isTyping": localTyping,
            ])
        }
    }
    private func observeTyping() -> ListenerRegistration {
        let listener = self.pairRef?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if(diff.document.documentID != self.__THIS__.Uid){
                    let friendIsTyping:Bool = diff.document.data()["isTyping"] as? Bool ?? false
                    if(friendIsTyping){
                        self.showTypingIndicator = true
                        self.scrollToBottom(animated: true)
                    }
                    else {
                        self.showTypingIndicator = false
                    }
                }
            }
            
        }
        return listener as! ListenerRegistration
        
    }
    //
    
    //    photo
    let storageRef = Storage.storage(url: "gs://iosonlinedating-7cc49.appspot.com").reference()
    private let imageURLNotSetKey = "NOTSET"
    
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            collectionView.reloadData()
        }
    }
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        // 1
        let storageRef = Storage.storage().reference(forURL: photoURL)
        // 2
        storageRef.getData(maxSize: INT64_MAX){ (data, error) in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }
            else{
                let image = UIImage(data: data!)
                mediaItem.image = image
                self.collectionView.reloadData()
                guard key != nil else {
                    return
                }
                self.photoMessageMap.removeValue(forKey: key!)
            }
        }
    }
    
    func sendPhotoMessage() -> String? {
        let messageItem = [
            "photoURL": imageURLNotSetKey,
            "sender_id": senderId!,
            "reciever_id": friend!.id,
            "create_date" : Date(),
            "text" : "sending a photo"
            ] as [String : Any]
        let itemRef = messageRef!.addDocument(data: messageItem)
 
        print(itemRef.documentID)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
        return itemRef.documentID
    }
    func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messageRef?.document(key)
        itemRef?.updateData([
            "photoURL": url,
        ])
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker.sourceType = UIImagePickerController.SourceType.camera
        } else {
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        present(picker, animated: true, completion:nil)
    }
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        }
        else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        換背景圖片
        let imgBackground:UIImageView = UIImageView(frame: self.view.bounds)
        imgBackground.image = UIImage(named: "index_test")
        imgBackground.contentMode = UIView.ContentMode.scaleAspectFill
        imgBackground.clipsToBounds = true
        self.collectionView?.backgroundView = imgBackground
        //        換輸入匡顏色
        //        self.inputToolbar.contentView.backgroundColor = UIColor.blackColor()
        
        if let _friend = friend{
            print("get friend success")
            self.title = _friend.name
        }
        if let _messageRef = messageRef{
            print("get message ref success")
        }
        if let _pairRef = pairRef{
            print("get pair ref success")
        }
        
        self.messageListener = self.observeMessages()
        self.typingListener = self.observeTyping()
        self.left = false
        //        這邊設置頭像大小
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    //
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.messageListener?.remove()
        self.typingListener?.remove()
        self.messageListener = nil
        self.typingListener = nil
        self.left = true
        
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let messageItem = [ // 2
            "sender_id": senderId,
            "receiver_id": friend?.id,
            "text": text!,
            "create_date": date!
            ] as [String : Any]
        messageRef!.addDocument(data: messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        finishSendingMessage() // 5
        isTyping = false
    }
    
    private func observeMessages() -> ListenerRegistration {
        let messageQuery = messageRef?.order(by: "create_date", descending: false)
        let listener = messageQuery?.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            let source = querySnapshot!.metadata.hasPendingWrites ? "Local" : "Server"
//            if source == "Server"{
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        print("viewcontroller偵測到新訊息: uid: \(diff.document.documentID)")
                        let id = diff.document.data()["sender_id"] as! String
                        let text = diff.document.data()["text"] as! String
                        var name:String!
                        if id == self.senderId {
                            name = self.__THIS__.Name
                        }
                        else{
                            name = self.friend?.name
                        }
                        if let photoURL:String = diff.document.data()["photoURL"] as? String { // 1
                            // 2
                            if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self.senderId) {
                                // 3
                                self.addPhotoMessage(withId: id, key: diff.document.documentID, mediaItem: mediaItem)
                                // 4
                                if photoURL.hasPrefix("gs://") {
                                    self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                                }
                            }
                            self.lastMessage = "sending a photo"
                            self.lastMessageDate = Date()
                        }
                        else{
                            self.addMessage(withId: id, name: name, text: text)
                            self.lastMessage = text
                            self.lastMessageDate = Date()
                        }
                        self.finishSendingMessage()
                    }
                    else if (diff.type == .modified){
                        //                    圖片被改掉了
                        print("viewcontroller偵測到修改訊息: uid: \(diff.document.documentID)")
                        let key = diff.document.documentID
                        if let photoURL = diff.document.data()["photoURL"] as? String { // 2
                            // The photo has been updated.
                            if photoURL != "NOTSET"{
                                if let mediaItem = self.photoMessageMap[key] { // 3
                                    self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key) // 4
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }

                
//            }
        }
        return listener as! ListenerRegistration
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        finishReceivingMessage()
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("after pick image")
        picker.dismiss(animated: true, completion:nil)
        // 1
        
        if let photoReferenceUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            // Handle picking a Photo from the Photo Library
            // 2
            let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
            let asset = assets.firstObject
            // 3
            if let key = sendPhotoMessage() {
                asset!.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                    let imageFileURL = contentEditingInput?.fullSizeImageURL
                    // 5
                    let path = "\(self.__THIS__.Uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"
                    // 6
                    self.storageRef.child(path).putFile(from: imageFileURL!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading photo: \(error.localizedDescription)")
                            return
                        }
                        // 7
                        self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
                    }
                })
            }
        }
        else {
            // Handle picking a Photo from the Camera - TODO
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

