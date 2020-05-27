//
//  ContentView.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/24.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI


struct ContentView: View {
    
    @EnvironmentObject var obs : Observer
    
    
    var body: some View {
        
        
        
        ZStack{
            Color("DarkBG").edgesIgnoringSafeArea(.all)
            
            if obs.users.isEmpty{
                Loader()
            }
            
            VStack{
                
                if self.obs.pageIndex == ENUM_CLASS.PAGES.AUTH_PAGE{
                    
                    AuthView()
                    
                }
                else if(self.obs.pageIndex == ENUM_CLASS.PAGES.SWIPE_PAGE){
                    // page for swiping
                    TopView()
                    SwipeView()
                    BottomView()
                    
                    
                }else{
                    TopView()
                    Spacer()
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
