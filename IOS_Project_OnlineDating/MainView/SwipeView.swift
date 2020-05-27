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
    
    var body: some View{
        
        GeometryReader{geo in
            
            ZStack{
                ForEach(self.obser.users){i in
                    
                    SwipeInfoView(name: i.name, age: i.age, image: i.image, height: geo.size.height - 50).gesture(DragGesture().onChanged({(value) in
                        
                        if value.translation.width > 0 {
                            self.obser.updateObs(user: i, swipeValue: value.translation.width, degree: 8)
                        }else{
                            self.obser.updateObs(user: i, swipeValue: value.translation.width, degree: -8)
                        }
                        
                    }).onEnded({(value) in
                        
                        if i.swipe > 0{
                            
                            if i.swipe > geo.size.width / 2 - 80{
                                // Swipe Like
                                self.obser.updateObs(user: i, swipeValue: 500, degree: 0)
                                
                                self.obser.updateDB(user: i, status: "liked")
                                
                            }else{
                                
                                self.obser.updateObs(user: i, swipeValue: 0, degree: 0)
                            }
                            
                        }else{
                            
                            if -i.swipe > geo.size.width / 2 - 80{
                                // Swipe Dislike
                                self.obser.updateObs(user: i, swipeValue: -500, degree: 0)
                                self.obser.updateDB(user: i, status: "disliked")
                            }else{
                                self.obser.updateObs(user: i, swipeValue: 0, degree: 0)
                            }
                            
                        }
                        
                    })
                    ).offset(x: i.swipe)
                        .rotationEffect(.init(degrees: i.degree))
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


