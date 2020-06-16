//
//  TopView.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/25.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI

struct TopView : View {
    
    @EnvironmentObject var obs:Observer
    
    var body: some View{
        VStack{
            if  self.obs.pageIndex == ENUM_CLASS.PAGES.SWIPE_PAGE{
                HStack(alignment: .top){
                    Button(action: {
                        
                        self.obs.pageIndex = ENUM_CLASS.PAGES.INFO_PAGE
                        
                    }){
                        Image("person").resizable().frame(width: 35, height: 35)
                    }.foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        self.obs.pageIndex = ENUM_CLASS.PAGES.SWIPE_PAGE
                        
                    }){
                        Image(systemName: "flame.fill").resizable().frame(width: 30, height: 35)
                    }.foregroundColor(.red)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        self.obs.pageIndex = ENUM_CLASS.PAGES.CHAT_PAGE
                        
                    }){
                        Image("chat").resizable().frame(width: 35, height: 35)
                    }.foregroundColor(.gray)
                }.padding()
            }
            else if self.obs.pageIndex == ENUM_CLASS.PAGES.CHAT_PAGE{
                HStack(alignment: .top){
                    
                    
                    Button(action: {
                        
                        self.obs.pageIndex = ENUM_CLASS.PAGES.SWIPE_PAGE
                        
                    }){
                        Image(systemName: "flame.fill").resizable().frame(width: 30, height: 35)
                    }.foregroundColor(.red)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        self.obs.pageIndex = ENUM_CLASS.PAGES.CHAT_PAGE
                        
                    }){
                        Image("chat").resizable().frame(width: 35, height: 35)
                    }.foregroundColor(.gray)
                    
                    Spacer()
                }.padding()
            }
            else{
                
                
                 
                HStack(alignment: .top){
                    
                    Spacer()
                    
                    Button(action: {
                        
                        self.obs.pageIndex = ENUM_CLASS.PAGES.INFO_PAGE
                        
                    }){
                        Image("person").resizable().frame(width: 35, height: 35)
                    }.foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        self.obs.pageIndex = ENUM_CLASS.PAGES.SWIPE_PAGE
                        
                    }){
                        Image(systemName: "flame.fill").resizable().frame(width: 30, height: 35)
                    }.foregroundColor(.red)
                    
                    
                    
                    
                }.padding()
            }
            
        }
        
        
    }
}

