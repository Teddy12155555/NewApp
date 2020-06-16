//
//  AuthView.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/25.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI

struct AuthView: View {
    
    @State var ACCOUNT_ = ""
    @State var PASSWORD = ""
    @State var SignupAccount = ""
    @State var SignupUid = ""
    @State var LOGIN = false
    @State var SIGNUP = false
    
    
    
    var body: some View {
        
        ZStack{
            // BG
            LinearGradient(gradient: .init(colors: [Color("Color1"),Color("Color2")]), startPoint: .leading, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            LoginView(Login: $LOGIN, Signup: $SIGNUP, Account: $ACCOUNT_, Password: $PASSWORD)
            
        }.sheet(isPresented: $SIGNUP){
            SignUpView(Signup: self.$SIGNUP, ACCOUNT_: self.$ACCOUNT_, PASSWORD: self.$PASSWORD,SignupAccount: self.$SignupAccount,SignupUid:self.$SignupUid)
        }
    }
}





