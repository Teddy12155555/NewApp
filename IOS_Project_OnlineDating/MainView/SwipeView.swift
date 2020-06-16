//
//  SwipeView.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/25.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI







struct SwipeView : View{

    @EnvironmentObject var obser:Observer
    
    func getMatchUsers()-> [User]{
        return Array(self.obser.matchUsers.values)
    }
    
    func updateCurrentUser(user:User){
        self.obser.CurrentMatchUser = user
    }

    var body: some View{

        GeometryReader{geo in
            ZStack{
                ForEach(self.getMatchUsers()){(user) in
//                    let user = self.obser.matchUsers[key]
//                    self.updateCurrentUser(user: user)
                    SwipeInfoView(name: user.name, age: user.age, image: user.image, height: geo.size.height - 50).gesture(DragGesture().onChanged({(value) in
                        self.updateCurrentUser(user: user)
                        if value.translation.width > 0 {
                            self.obser.updateObs(user: user, swipeValue: value.translation.width, degree: 8)
                        }
                        else{
                            self.obser.updateObs(user: user, swipeValue: value.translation.width, degree: -8)
                        }

                    }).onEnded({(value) in

                        if user.swipe > 0{
                            if user.swipe > geo.size.width / 2 - 80{
                                // Swipe Like
                                self.obser.updateObs(user: user, swipeValue: 500, degree: 0)
                                self.obser.updateDB(user: user, liked: true)
                            }
                            else{
                                self.obser.updateObs(user: user, swipeValue: 0, degree: 0)
                            }

                        }
                        else{
                            if -user.swipe > geo.size.width / 2 - 80{
                                // Swipe Dislike
                                self.obser.updateObs(user: user, swipeValue: -500, degree: 0)
                                self.obser.updateDB(user: user, liked: false)
                            }
                            else{
                                self.obser.updateObs(user: user, swipeValue: 0, degree: 0)
                            }

                        }

                    })
                    ).offset(x: user.swipe)
                        .rotationEffect(.init(degrees: user.degree))
                        .animation(.spring())
                }
            }
            
        }
    }
}

struct SwipeInfoView:View {
    var name = ""
    var age = ""
    var image = ""
    var height:CGFloat = 0
    var body:some View{
        ZStack{
            
            AnimatedImage(url: URL(string: image)!).resizable().cornerRadius(20).padding(.horizontal,15)
            VStack{
                Spacer()
                HStack{
                    VStack(alignment: .leading,content: {
                        Text(name).fontWeight(.heavy).font(.system(size: 25)).foregroundColor(.white)
                        Text(age).foregroundColor(.white)
                    })
                    
                    Spacer()
                    
                }.padding([.bottom,.leading],35)
                
            }.frame( height: height)
        }
    }
}





