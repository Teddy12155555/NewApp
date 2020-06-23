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
    
    init() {
        
    }
    
    var body: some View{
        
        GeometryReader{geo in
            HStack{
                Button(action: {
                    if(self.obs.CurrentMatchUser != nil){
                        print(self.obs.CurrentMatchUser.id)
                        self.obs.updateObs(user: self.obs.CurrentMatchUser, swipeValue: -500, degree: 0)
                        self.obs.updateDB(user: self.obs.CurrentMatchUser, liked: false)
                    }
                    
                    
                }){
                    Image("dislike").resizable().frame(width: 35, height: 35).padding()
                    }
                    .foregroundColor(.pink)
                    .background(Color.white)
                    .shadow(radius: 25)
                    .clipShape(Circle())
                .padding(.horizontal,30)
                
                Button(action: {
                    print("clicked like btn")
                    if(self.obs.CurrentMatchUser != nil){
                        print("clicked like btn")
                        print(self.obs.CurrentMatchUser.id)
                        self.obs.updateObs(user: self.obs.CurrentMatchUser, swipeValue: 500, degree: 0)
                        self.obs.updateDB(user: self.obs.CurrentMatchUser, liked: true)
                    }
                    
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



struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
