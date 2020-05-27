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


struct LoginView:View {
    @EnvironmentObject var obs : Observer
    
    @Binding var Login : Bool
    @Binding var Signup : Bool
    @Binding var Account : String
    @Binding var Password : String
    
    @State var Visble:Bool = true
    
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
                        self.obs.__THIS__.Uid = user.uid as! String
                        
                        if self.obs.loadRelationship() == true{
                            print("It work")
                        }
                        
                    }else{
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


