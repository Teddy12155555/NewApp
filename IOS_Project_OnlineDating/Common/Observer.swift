//
//  Observer.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/26.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

class Observer: ObservableObject {
    
    @Published var __THIS__  = THIS(id: "", Uid: "", Name: "", Age: "", Image_: "", Sex: "")
    @Published var users = [User]()
    @Published var last = -1
    @Published var pageIndex:ENUM_CLASS.PAGES = .AUTH_PAGE
    @Published var relationship:[String:String] = [:]
    
    //    @Published var matchUsers = [User]()
    //    @Published var pairUsers = [User]()
    
    
    //    這邊避免用array存 用dict存取資訊
    //    key為matchUid
    @Published var matchUsers:[String:User] = [:]
    //    key為pairUid
    @Published var pairUsers:[String:User] = [:]
    
    //    這邊用來存每個pair之message listener key為pairUid
    @Published var pairMessageListener:[String:ListenerRegistration] = [:]
    
    //    key為pairUid value為訊息
    @Published var pairLastMessages:[String:String] = [:]
    @Published var pairLastMessagesDate:[String:Date] = [:]
    
    var db = Firestore.firestore()
    
    
    
    init() {
    }
    
    //
    func addMessageListenerForPair(_ pairUid:String){
        if(self.pairMessageListener[pairUid] != nil){
            return
        }
        let messageQuery = self.db.collection("pairs").document(pairUid).collection("messages").order(by: "create_date", descending: false)
        let listener = messageQuery.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("偵測到新訊息: uid: \(diff.document.documentID)")
                    self.pairLastMessages[pairUid] = diff.document.data()["text"] as? String ?? ""
//                    print(diff.document.data()["text"] as? String ?? "")
                    self.pairLastMessagesDate[pairUid] = diff.document.data()["create_date"] as? Date ?? Date()
                    
                    
                }
            }
        }
        self.pairMessageListener[pairUid] = listener
    }
    //
    
    func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    
    func updateObs(user:User,swipeValue:CGFloat,degree:Double){
        //        original version is users
        self.matchUsers[user.matchUid]?.swipe = swipeValue
        self.matchUsers[user.matchUid]?.degree = degree
        
        
        //        for i in 0..<self.matchUsers.count{
        //            if self.matchUsers[i].id == user.id{
        //                self.matchUsers[i].swipe = swipeValue
        //                self.matchUsers[i].degree = degree
        //                self.last = i
        //            }
        //        }
    }
    
    //    TMING
    func updateDB(user:User,status:String){
        let db = Firestore.firestore()
        db.collection("users").document(user.id).updateData(["status":status]) {(err) in
            if err != nil{
                print(err)
                return
            }
            for i in 0..<self.users.count{
                if self.users[i].id == user.id{
                    if status == "liked"{
                        self.users[i].swipe = 500
                    }
                    else if status == "disliked"{
                        self.users[i].swipe = -500
                        
                    }
                    else{
                        
                        self.users[i].swipe = 0
                    }
                }
            }
            
        }
    }
    
    
    
    //    當用戶登入創立此listener
    func createMatchListener(){
        let listener = self.db.collection("to_be_match").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                //                修改代表，配對可能被改掉了，代表有人左滑 或右滑了他
                if (diff.type == .modified) {
                    print("偵測到修改: 修改match uid: \(diff.document.documentID)")
                    let userA_status : Int = diff.document.data()["userA_status"] as! Int
                    let userB_status : Int = diff.document.data()["userB_status"] as! Int
                    //                    這邊可能還要加狀態去判斷 match狀態
                    //                    ex:已經左滑過 或右滑過就不會再出現在頁面上
                    if(userA_status > 0 && userB_status > 0){
                        print("配對成功")
                        //                        取雙方UID
                        let userA_id = diff.document.data()["userA_id"] as! String
                        let userB_id = diff.document.data()["userB_id"] as! String
                        let newPairRef = self.db.collection("pairs").addDocument(data:
                            [
                                "userA_id" : userA_id,
                                "userB_id" : userB_id,
                                "create_date" : Date(),
                        ])
                        //                        判斷若跟本地用戶有關 把新的配對用戶資訊加入 local用戶之pairs名單中
                        //                        應該從array 裡移除對應match user
                        if(userA_id == self.__THIS__.Uid){
                            self.addPairUser(userB_id, newPairRef.documentID)
                        }
                        else if (userB_id == self.__THIS__.Uid){
                            self.addPairUser(userB_id, newPairRef.documentID)
                        }
                        print("新配對完成 pair uid: \(newPairRef.documentID)")
                    }
                }
                    //                    這邊代表一開始登入可能會先抓出所有新增的match id，也去檢查是否跟本地用戶有關
                else if (diff.type == .added){
                    print("偵測到新增：新增match uid: \(diff.document.documentID)")
                    let userA_id:String = diff.document.data()["userA_id"] as! String
                    let userB_id:String = diff.document.data()["userB_id"] as! String
                    let status:Int = diff.document.data()["status"] as? Int ?? 0
                    if(status == 0){
                        if (userA_id == self.__THIS__.Uid){
                            self.db.collection("users").document(userB_id).getDocument { (userDocument, error) in
                                if let userDocument = userDocument, userDocument.exists {
                                    print(userB_id + "get")
                                    let uid = userDocument.documentID
                                    let sex = userDocument.data()!["sex"] as? String ?? ""
                                    let image = userDocument.data()!["image"] as? String ?? ""
                                    let age = userDocument.data()!["age"] as? String ?? ""
                                    let name = userDocument.data()!["name"] as? String ?? ""
                                    self.matchUsers[diff.document.documentID] = User(id: uid, name: name, image: image, age: age, sex: sex, swipe: 0, degree: 0, matchUid:diff.document.documentID)
                                    print("match user size = \(self.matchUsers.count)")
                                }
                                else {
                                    print("cant find \(userB_id) in users table")
                                }
                            }
                        }
                        else if(userB_id == self.__THIS__.Uid){
                            self.db.collection("users").document(userA_id).getDocument { (userDocument, error) in
                                if let userDocument = userDocument, userDocument.exists {
                                    print(userA_id + "get")
                                    let uid = userDocument.documentID
                                    let sex = userDocument.data()!["sex"] as? String ?? ""
                                    let image = userDocument.data()!["image"] as? String ?? ""
                                    let age = userDocument.data()!["age"] as? String ?? ""
                                    let name = userDocument.data()!["name"] as? String ?? ""
                                    self.matchUsers[diff.document.documentID] = User(id: uid, name: name, image: image, age: age, sex: sex, swipe: 0, degree: 0, matchUid:diff.document.documentID)
                                    print("match user size = \(self.matchUsers.count)")
                                }
                                else {
                                    print("cant find \(userA_id) in users table")
                                }
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    //    從firebase 即時 access 對應uid 之 user 資訊以及設置其對應的pair id
    func addPairUser(_ uid:String,_ pairUid:String){
        self.db.collection("users").document(uid).getDocument{
            (userDocument, error) in
            if let userDocument = userDocument, userDocument.exists {
                let name = userDocument.get("name") as? String ?? ""
                let age = userDocument.get("age") as? String ?? ""
                let image = userDocument.get("image") as? String ?? ""
                let sex = userDocument.get("sex") as? String ?? ""
                let id = userDocument.documentID
                print("when pairs get user: \(id)")
                self.pairUsers[pairUid] = User(id: id, name: name, image: image, age: age, sex: sex, swipe: 0, degree: 0,pairUid: pairUid)
                //                self.pairUsers.append(User(id: id, name: name, image: image, age: age, sex: sex, swipe: 0, degree: 0,pairUid: pairUid))
                print("pairs user size \(self.pairUsers.count)")
            }
            else {
                print("cant find \(uid) in users table")
            }
        }
    }
    
    
    //    當用戶登入之後 check他所有的已配對好友
    func createPairsListener(){
        let listener = self.db.collection("pairs").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                //                若有新增，則存到local 變數 pairUsers
                if (diff.type == .added){
                    print("偵測到新增pair: uid: \(diff.document.documentID)")
                    let userA_id : String = diff.document.data()["userA_id"] as! String
                    let userB_id : String = diff.document.data()["userB_id"] as! String
                    if(userA_id == self.__THIS__.Uid){
                        self.addPairUser(userB_id,diff.document.documentID)
                        self.addMessageListenerForPair(diff.document.documentID)
                    }
                    else if(userB_id == self.__THIS__.Uid){
                        self.addPairUser(userA_id,diff.document.documentID)
                        self.addMessageListenerForPair(diff.document.documentID)
                    }
                }
            }
        }
    }
    
    
    
    
    func updateDB(user:User,liked:Bool){
        let db = Firestore.firestore()
        db.collection("to_be_match").document(user.matchUid).getDocument { (document, error) in
            if let document = document, document.exists {
                print("更改math uid:" + document.documentID)
                if(document.data()!["userA_id"] as! String == self.__THIS__.Uid){
                    db.collection("to_be_match").document(user.matchUid).updateData([
                        "userA_status" : 1,
                    ])
                    
                }
                else if(document.data()!["userB_id"] as! String == self.__THIS__.Uid){
                    db.collection("to_be_match").document(user.matchUid).updateData([
                        "userB_status" : 1,
                    ])
                }
                print("modify success")
            }
            else {
                print("Document does not exist")
            }
            //            這邊代表更改matchUser中的位置
            if liked {
                self.matchUsers[user.matchUid]?.swipe = 500
            }
            else {
                self.matchUsers[user.matchUid]?.swipe = -500
            }
            
        }
    }
    
    func reloadThis() -> Bool{
        
        let myGroup = DispatchGroup()
        if __THIS__.Uid == "" || users.count == 0{
            return false
        }
        else{
            myGroup.enter()
            for j in 0..<self.users.count{
                if self.users[j].id == self.__THIS__.Uid{
                    
                    self.__THIS__.SetThis(id_: self.users[j].id, uid: self.users[j].id, name: self.users[j].name, age: self.users[j].age, image: self.users[j].image, sex: self.users[j].sex)
                    print("Find self : \(self.__THIS__)")
                    self.users.remove(at: j)
                    break
                }
                
            }
            myGroup.leave()
            pageIndex =
                ENUM_CLASS.PAGES.SWIPE_PAGE
            return true
        }
    }
    
    //
    func loadRelationship(){
        let db = Firestore.firestore()
        db.collection("relationship").document(self.__THIS__.Uid).getDocument{(data,err) in
            if err != nil{
                print("Error")
            }
            
            self.relationship = data?.data() as! [String:String]
            
            self.relationship.remove(at: self.relationship.index(forKey: "selfinit")!)
            
        }
    }
    func updateDB(relation : RelationShip,status:String){
        let db = Firestore.firestore()
        db.collection("relationship").document(self.__THIS__.Uid).getDocument{(data,err) in
            if err != nil{
                print("Error")
            }
        }
    }
    
    
    
    //    hongyun Part
    
    
}
