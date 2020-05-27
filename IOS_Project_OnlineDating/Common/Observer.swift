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
    
    init() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments{ (snap,err) in
            if err != nil{
                print("Database Errpr : ")
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documents{
                let name = i.get("name") as! String
                let age = i.get("age") as! String
                let image = i.get("image") as! String
                //let status = i.get("status") as! String
                let sex = i.get("sex") as! String
                let id = i.documentID
                
                self.users.append(User(id: id, name: name, image: image, age: age, sex: sex, swipe: 0, degree: 0))
//                if status == ""{
//
//                }
                
                
            }
        }
    }
    
    func updateObs(user:User,swipeValue:CGFloat,degree:Double){
        for i in 0..<self.users.count{
            if self.users[i].id == user.id{
                self.users[i].swipe = swipeValue
                self.users[i].degree = degree
                self.last = i
            }
        }
    }
    
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
                        
                    }else if status == "disliked"{
                        
                        self.users[i].swipe = -500
                        
                    }
                    else{
                        
                        self.users[i].swipe = 0
                    }
                }
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
    
}
