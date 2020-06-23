//
//  DataType.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/26.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI

struct THIS : Identifiable  {
    
    // Id 's id
    var id: String
    // DB 's uid
    var Uid : String
    var Name : String
    var Age : String
    var Image_ : String
    var Sex : String
    var Intro : String
    var matchSex:String = "Both"
    var matchAgeFrom:Int = 0
    var matchAgeTo:Int = 99
    
    mutating func SetUID(uid:String){
        Uid = uid
    }
    mutating func SetThis(id_:String,uid:String,name:String,age:String,image:String,sex:String,intro:String,matchsex:String,matchagefrom:Int,matchageto:Int){
        
        id = id_
        Uid = uid
        Name = name
        Age = age
        Image_ = image
        Sex = sex
        Intro = intro
        matchSex = matchsex
        matchAgeFrom = matchagefrom
        matchAgeTo = matchageto
        
    }
}

struct User : Identifiable {
    var id:String
    var name:String
    var image:String
    var age:String
    var sex:String
    var swipe:CGFloat
    var degree:Double
    var intro:String
    var pairUid:String = ""
    var matchUid:String = ""
    var matchSex:String = "Both"
    var matchAgeFrom:Int = 0
    var matchAgeTo:Int = 99
}

//
//struct Msg : Identifiable {
//    var id : String
//    var sender_id : String
//    var receiver_id : String
//    var text : String
//    var date : String
//}

struct RelationShip : Identifiable {
    var id:String
    var status:String
}
