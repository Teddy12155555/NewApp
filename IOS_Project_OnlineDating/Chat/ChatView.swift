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
            //            if(self.obser.pairMessageListener[friend.pairUid] == nil){
            //                self.obser.addMessageListenerForPair(friend.pairUid)
            //            }
            //            if(uiViewController.lastMessageDate != nil){
            //                self.obser.pairLastMessagesDate[friend.pairUid] = uiViewController.lastMessageDate
            //                self.obser.pairLastMessages[friend.pairUid] = uiViewController.lastMessage
            //            }
            if(!self.obser.messageListenerFlag[friend.pairUid]!){
                //                self.obser.pairMessageListener[friend.pairUid]?.remove()
                //                self.obser.pairMessageListener[friend.pairUid] = nil
                self.obser.messageListenerFlag[friend.pairUid] = true
                if( uiViewController.lastMessageDate != nil){
                    self.obser.pairLastMessages[friend.pairUid] = uiViewController.lastMessage
                    self.obser.pairLastMessagesDate[friend.pairUid] = uiViewController.lastMessageDate
                    uiViewController.lastMessageDate = nil
                    uiViewController.lastMessage  = ""
                    
                }
                
                
            }
        }
//        else{
//            if(self.obser.messageListenerFlag[friend.pairUid]!){
//                //                self.obser.pairMessageListener[friend.pairUid]?.remove()
//                //                self.obser.pairMessageListener[friend.pairUid] = nil
//                self.obser.messageListenerFlag[friend.pairUid] = false
//            }
//        }
        //        self.obser.pairMessageListener[friend.pairUid] = uiViewController.messageListener
        
        
    }
    
    func makeUIViewController(context: Context) -> ChatViewController {
        let chatViewController = ChatViewController()
        chatViewController.senderId = self.obser.__THIS__.Uid
        chatViewController.senderDisplayName = self.obser.__THIS__.Name
        chatViewController.friend = self.friend
        chatViewController.messageRef = self.db.collection("pairs").document(self.friend.pairUid).collection("messages")
        chatViewController.pairRef = self.db.collection("pairs").document(self.friend.pairUid).collection("typingIndicator")
        chatViewController.__THIS__ = self.obser.__THIS__
        self.obser.messageListenerFlag[friend.pairUid] = false
        return chatViewController
    }
    
    typealias UIViewControllerType = ChatViewController
    
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
