//
//  AlertView.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/25.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI

struct AlertView: View {
    
    
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: .init(colors: [Color("Color7"),Color("Color8")]), startPoint: .leading, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
        }
        
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
