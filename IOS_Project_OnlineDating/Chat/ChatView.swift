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
    }
    
    func makeUIViewController(context: Context) -> ChatViewController {
        let chatViewController = ChatViewController()
        chatViewController.senderId = self.obser.__THIS__.Uid
        chatViewController.senderDisplayName = self.obser.__THIS__.Name
        chatViewController.friend = self.friend
        chatViewController.messageRef = self.db.collection("pairs").document(self.friend.pairUid).collection("messages")
        chatViewController.pairRef = self.db.collection("pairs").document(self.friend.pairUid).collection("typingIndicator")
        chatViewController.__THIS__ = self.obser.__THIS__
        return chatViewController
    }
    
    typealias UIViewControllerType = ChatViewController
    
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
