//
//  BottomView.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/25.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI

struct BottomView : View {
    
    @EnvironmentObject var obs:Observer
    
    var body: some View{
        
        GeometryReader{geo in
            
            HStack{
                Button(action: {
                    
                    
                }){
                    Image("dislike").resizable().frame(width: 35, height: 35).padding()
                    }
                    .foregroundColor(.pink)
                    .background(Color.white)
                    .shadow(radius: 25)
                    .clipShape(Circle())
                .padding(.horizontal,30)
                
                Button(action: {
                    
                    print(self.obs.last)
                    
                }){
                    Image("like").resizable().frame(width: 35, height: 35).padding()
                    }
                .foregroundColor(.green)
                    .background(Color.white)
                    .shadow(radius: 25)
                    .clipShape(Circle())
                .padding(.horizontal,30)
                
            }
        }.frame(height: 100)
        
        
    }
}


