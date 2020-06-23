//
//  ChatView.swift
//  IOS_Project_OnlineDating
//
//  Created by 姜宏昀 on 2020/5/30.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI
import Firebase


struct ChatView: UIViewControllerRepresentable {
    
    @EnvironmentObject var obser:Observer

    
    var db = Firestore.firestore()
    var friend:User!
    var messageRef:CollectionReference!
    var pairRef:CollectionReference!
    
    init(friend:User){
        self.friend = friend
        
    }
    
    func updateUIViewController(_ uiViewController: ChatViewController, context: Context) {
        if(uiViewController.left){
//            這邊代表把外面的Listener 打開
            if(!self.obser.messageListenerFlag[friend.pairUid]!){
                self.obser.messageListenerFlag[friend.pairUid] = true
                if( uiViewController.lastMessageDate != nil){
                    self.obser.pairLastMessages[friend.pairUid] = uiViewController.lastMessage
                    self.obser.pairLastMessagesDate[friend.pairUid] = uiViewController.lastMessageDate
                }
            }
            
        }
        
    }
    func makeUIViewController(context: Context) -> ChatViewController {
        let chatViewController = ChatViewController()
        
        
//        self.navigationBarTitle(Text(self.friend.name))
        
        
        chatViewController.title = self.friend.name
        chatViewController.senderId = self.obser.__THIS__.Uid
        chatViewController.senderDisplayName = self.obser.__THIS__.Name
        chatViewController.friend = self.friend
        chatViewController.messageRef = self.db.collection("pairs").document(self.friend.pairUid).collection("messages")
        chatViewController.pairRef = self.db.collection("pairs").document(self.friend.pairUid).collection("typingIndicator")
        chatViewController.__THIS__ = self.obser.__THIS__
        
        let _url = URL(string: self.friend.image)!
        if let data = try? Data(contentsOf: _url) {
            chatViewController.friendImage = UIImage(data: data)
        }
        
        chatViewController.navigationItem.title = self.friend.name
        
        self.obser.messageListenerFlag[friend.pairUid] = false
        
        
        
        
//        未讀訊息歸0
        self.obser.unreadMessageCount[friend.pairUid]? = 0
            
        
        return chatViewController
    }
    
    typealias UIViewControllerType = ChatViewController
    
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
