//
//  LoginView.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/25.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import PromiseKit


struct LoginView:View {
    @EnvironmentObject var obs : Observer
    
    @Binding var Login : Bool
    @Binding var Signup : Bool
    @Binding var Account : String
    @Binding var Password : String
    
    let db = Firestore.firestore()
    @State var LoginUid:String!
    
    
    
    @State var Visble:Bool = true
    
    
    
//    func getMatchesData(){
//        let group = DispatchGroup()
//        group.enter()
//        getMatchesPromiseB().then{
//            documents->Promise<()> in
//            print(documents.count)
//            return self.getUserInfoPromiseFromMatchA(documents)
//        }.done{
//            data in
//            group.leave()
//        }
//        group.enter()
//        getMatchesPromiseA().then{
//            documents->Promise<()> in
//            print(documents.count)
//            return self.getUserInfoPromiseFromMatchB(documents)
//        }.done{
//            data in
//            group.leave()
//        }
//        group.notify(queue: .main, execute: {
//            print("other user size \(self.obs.matchUsers.count)")
//            self.obs.pageIndex =  ENUM_CLASS.PAGES.SWIPE_PAGE
//        })
//
//    }
    //            return Matches document，且userB_id 為Login User uid
//    func getMatchesPromiseB() -> Promise<[QueryDocumentSnapshot]>{
//        return Promise<[QueryDocumentSnapshot]>{ resolver in
//            self.db.collection("to_be_match").whereField("userB_id", isEqualTo: LoginUid)
//                .getDocuments() { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                        resolver.reject(err)
//                    }
//                    else {
//                        resolver.fulfill(querySnapshot!.documents)
//                    }
//            }
//
//        }
//    }
    
    //            return Matches document，且userA_id 為Login User uid
//    func getMatchesPromiseA() -> Promise<([QueryDocumentSnapshot])>{
//        return Promise<[QueryDocumentSnapshot]>{ resolver in
//            self.db.collection("to_be_match").whereField("userA_id", isEqualTo: LoginUid)
//                .getDocuments() { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                        resolver.reject(err)
//                    }
//                    else {
//                        resolver.fulfill(querySnapshot!.documents)
//                    }
//            }
//        }
//    }
    
    //    取出Document內 欄位為userB_id 之user
//    func getUserInfoPromiseFromMatchB(_ matchDocuments:[QueryDocumentSnapshot]) -> Promise<()>{
//        return Promise<()>{ resolver in
//            let group = DispatchGroup()
//            for document in matchDocuments{
//                let uid:String = document.data()["userB_id"] as! String
//                group.enter()
//                self.db.collection("users").document(uid).getDocument { (userDocument, error) in
//                    if let userDocument = userDocument, userDocument.exists {
//                        print(uid + " get")
//
//                        let uid = userDocument.documentID
//                        let sex = userDocument.data()!["sex"] as? String ?? ""
//                        let image = userDocument.data()!["image"] as? String ?? ""
//                        let age = userDocument.data()!["age"] as? String ?? ""
//                        let name = userDocument.data()!["name"] as? String ?? ""
//                        self.obs.matchUsers.append(User(id: uid, name: name, image: image, age: age, sex: sex, swipe: 0, degree: 0,matchUid:document.documentID))
////                        self.obs.matchUsers.append(User(id: uid, name: name, image: image, age: age, sex: sex, swipe: 0, degree: 0))
//
//                    }
//                    else {
//                        print("cant find \(uid) in users table")
//                    }
//                    group.leave()
//                }
//            }
//            group.notify(queue: .main, execute: {
//                resolver.fulfill(())
//            })
//        }
//    }
    
    //    取出Document內 欄位為userA_id 之user
//    func getUserInfoPromiseFromMatchA(_ matchDocuments:[QueryDocumentSnapshot]) -> Promise<()>{
//        return Promise<()>{ resolver in
//            var count = matchDocuments.count
//            let group = DispatchGroup()
//            for document in matchDocuments{
//                let uid:String = document.data()["userA_id"] as! String
//                group.enter()
//                self.db.collection("users").document(uid).getDocument { (userDocument, error) in
//                    if let userDocument = userDocument, userDocument.exists {
//
//                        let uid = userDocument.documentID
//                        let sex = userDocument.data()!["sex"] as? String ?? ""
//                        let image = userDocument.data()!["image"] as? String ?? ""
//                        let age = userDocument.data()!["age"] as? String ?? ""
//
//                        let name = userDocument.data()!["name"] as? String ?? ""
////                        self.obs.users.append(User(id: uid, name: name, image: image, age: age, sex: sex, swipe: 0, degree: 0))
//                        self.obs.matchUsers.append(User(id: uid, name: name, image: image, age: age, sex: sex, swipe: 0, degree: 0,matchUid:document.documentID))
//
//                    }
//                    else {
//                        print("cant find \(uid) in users table")
//                    }
//                    group.leave()
//                }
//            }
//            group.notify(queue: .main, execute: {
//                resolver.fulfill(())
//            })
//
//        }
//    }
    
    
    
    var body: some View{
        
        VStack(alignment: .center, spacing: 15){
            
            // Logo
            Image("Logo").resizable().frame(width: 100, height: 100).padding(.bottom,70)
            
            // Account field
            HStack{
                Image(systemName: "person.fill").resizable().frame(width: 20, height: 20)
                
                TextField("Account",text: $Account).padding(.leading,12).font(.system(size: 20)).autocapitalization(.none)
                
            }.padding(12)
                .background(Color.white).cornerRadius(20)
                .background(RoundedRectangle(cornerRadius: 20).stroke(self.Account != "" ? Color("Color9") : Color.white,lineWidth: 5))
            
            
            // Password field
            HStack{
                
                Image(systemName: "lock.fill").resizable().frame(width: 20, height: 20)
                
                VStack{
                    if self.Visble{
                        HStack{
                            
                            SecureField("Password",text: $Password).padding(.leading,12).font(.system(size: 20)).autocapitalization(.none)
                            
                        }
                    }else{
                        
                        TextField("Password",text: $Password).padding(.leading,12).font(.system(size: 20)).autocapitalization(.none)
                    }
                    
                }
                
                Button(action: {
                    self.Visble.toggle()
                }){
                    Image(systemName: self.Visble ? "eye.fill" : "eye.slash.fill")
                }
                
                
            }.padding(12)
                .background(Color.white)
                .cornerRadius(20)
                .background(RoundedRectangle(cornerRadius: 20).stroke(self.Password != "" ? Color("Color9") : Color.white,lineWidth: 5))
            
            // Button Login
            Button(action: {
                
                if self.Account != "" && self.Password != "" {
                    
                    Auth.auth().signIn(withEmail: self.Account, password: self.Password){(result,err) in
                        
                        if err != nil{
                            print("Login Error with bad code: \(err)")
                            return
                        }

                        if let user = Auth.auth().currentUser{
                            print("Success with User : \(user.uid)")
                            self.LoginUid = user.uid
                            self.obs.__THIS__.Uid = user.uid as! String
                            self.obs.createMatchListener()
                            self.obs.createPairsListener()
                            self.db.collection("users").document(self.obs.__THIS__.Uid).getDocument{
                                (userDocument,err) in
                                if let userDocument = userDocument, userDocument.exists {
                                    self.obs.__THIS__.Name = userDocument.data()?["name"] as? String ?? "noname"
                                }
                                else {
                                    print("cant find \(user.uid) in users table")
                                }
                            }
                            self.obs.pageIndex =  ENUM_CLASS.PAGES.SWIPE_PAGE
                        }
                        else{
                            print("Fail")
                        }
                        
                    }
                    
                }
                
            }){
                Text("Login").foregroundColor(.white).padding().frame(width: 200,height: 40)
            }.background(LinearGradient(gradient: .init(colors: [Color("Color3"),Color("Color4")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(40)
                .offset( y: 15)
                .shadow(radius: 25)
            
            // Button Sign up
            HStack{
                Text("還沒有帳號嗎？").foregroundColor(.white)
                
                Button(action: {
                    
                    self.Signup.toggle()
                    
                }){
                    Text("註冊一個").underline().foregroundColor(.white)
                }
            }.padding(.top,30)
            
            
            
            
            
        }.padding(.horizontal,18).offset( y: 15)
    }
}


