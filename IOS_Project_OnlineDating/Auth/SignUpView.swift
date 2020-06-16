//
//  SignUpView.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/25.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct SignUpView:View {
    
    @EnvironmentObject var obs : Observer
    
    @Binding var Signup : Bool
    @Binding var ACCOUNT_ : String
    @Binding var PASSWORD : String
    
//    @Binding var USER_ID : String
    
    @Binding var SignupAccount : String
    @Binding var SignupUid : String
    
    
    @State var Index = ENUM_CLASS.SIGN_UP_PAGES.EMAIL_PAGE
    
    @State var SIGNAccount = ""
    @State var SIGNPassword = ""
        

    
    let db = Firestore.firestore()

    
    

    
    
    
    var body: some View{
        
        ZStack{
            
            LinearGradient(gradient: .init(colors: [Color("Color5"),Color("Color6")]), startPoint: .top, endPoint: .bottom)
            // Email Sign Up
            
            if Index == ENUM_CLASS.SIGN_UP_PAGES.EMAIL_PAGE{
                
                VStack(alignment: .center, spacing: 15){
                
                    Text("使用 Email 註冊").foregroundColor(.black).fontWeight(.heavy).font(.system(size: 40)).padding(.bottom,40)
                    
                    VStack{
                        
                        TextField("Email",text: $SIGNAccount).padding(.leading,12).font(.system(size: 20)).autocapitalization(.none).foregroundColor(.secondary)
                        
                        Divider()
                        .frame(height: 2)
                        .padding(.horizontal, 30)
                            .background(Color.gray)
                        
                        Button(action: {
                            
                            if self.SIGNAccount != ""{
                                Auth.auth().fetchSignInMethods(forEmail: self.SIGNAccount){(result,err) in
                                    if err != nil{
                                        print("Fetch Error : \(err)")
                                        return
                                    }
                                    if result == nil{
                                        self.Index = .PASSWORD_PAGE
                                    }else{
                                        
                                        print("Account already exist !")
                                        
                                    }
                                    
                                }
                                
                                
                            }
                            
                       
                        }){
                            Text("繼續").foregroundColor(.white).padding().frame(width: 200,height: 40)
                        }.background(LinearGradient(gradient: .init(colors: [Color("Color7"),Color("Color8")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .offset( y: 15)
                        .shadow(radius: 25)
                        
                    }.padding(12)
                    
                    
                    
                }.padding(.horizontal,18).offset( y: 15)
            }
            else if Index == ENUM_CLASS.SIGN_UP_PAGES.PASSWORD_PAGE{
                
                VStack(alignment: .center, spacing: 15){
                
                    Text("請輸入密碼").foregroundColor(.black).fontWeight(.heavy).font(.system(size: 40)).padding(.bottom,40)
                    
                    VStack{
                        
                        SecureField("Password",text: $SIGNPassword).padding(.leading,12).font(.system(size: 20)).autocapitalization(.none).foregroundColor(.secondary)
                        
                        Divider()
                        .frame(height: 2)
                        .padding(.horizontal, 30)
                            .background(Color.gray)
                        
                        Button(action: {
                            
                            if self.SIGNPassword != ""{
                                
                                Auth.auth().createUser(withEmail: self.SIGNAccount, password: self.SIGNPassword){(result,err) in
                                    if err != nil{
                                        print("Sign up Error with bad code: \(err)")
                                        return
                                    }
                                    
                                    // Finish sign up
                                    self.ACCOUNT_ = self.SIGNAccount
                                    self.PASSWORD = self.SIGNPassword
                                    self.SignupAccount = self.SIGNAccount
                                    self.SignupUid = result?.user.uid as! String
                                    self.Index = .INFO_PAGE
                                }
                                
                            }
                            
                       
                        }){
                            Text("註冊").foregroundColor(.white).padding().frame(width: 200,height: 40)
                        }.background(LinearGradient(gradient: .init(colors: [Color("Color7"),Color("Color8")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .offset( y: 15)
                        .shadow(radius: 25)
                        
                    }.padding(12)
                    
                    
                    
                }.padding(.horizontal,18).offset( y: 15)
                
            }
            // Fill Basic Info
            else if Index == ENUM_CLASS.SIGN_UP_PAGES.INFO_PAGE{
                
                // Call InfoView
                InfoView(Signup: self.$Signup, SignupAccount: self.$SignupAccount, SignupUid: self.$SignupUid)
            }
        }
        
    }
}


//struct pr:PreviewProvider {
//    static var previews: some View{
//        SignUpView(Signup: .constant(true), ACCOUNT_: .constant(""), PASSWORD: .constant(""))
//    }
//}
