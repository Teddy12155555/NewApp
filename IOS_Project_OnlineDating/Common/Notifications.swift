//
//  Notifications.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/27.
//  Copyright © 2020 黃泰銘. All rights reserved.
//
import SwiftUI
import UserNotifications

func SendNotification(title: String,body:String){
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){ (status,_) in
        
        if status{
            
            return
        }
        
        let content = UNMutableNotificationContent()
        //content.title = "🚨~甲甲警報~🚨"
        //content.body = "您已被甲甲造訪且配對，趕快搞肛！"
        content.title = title
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "match", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { err in
            print(err)
            
        })
        
    }
}


struct Alert:View {
    
    var body: some View{
        ZStack{
            VStack{
                
                HStack{
                    
                    Button(action: {}){
                        Image("match").renderingMode(.original).resizable().frame(width: 100, height: 100)
                    }.background(Color.white).clipShape(Circle()).padding(.top,20)
                    
                    
                }
                Text("Hello")
                HStack{
                    Button(action: {}){
                        Text("馬上聊天")
                    }
                    
                    Button(action: {}){
                        Text("Close")
                    }
                }
            }
        }.frame(width: 200, height: 250).cornerRadius(40).background(Color.gray)
            
    }
}
struct pr:PreviewProvider {
    static var previews: some View
    {
        ZStack{
            Alert()
        }
        
    }
}
