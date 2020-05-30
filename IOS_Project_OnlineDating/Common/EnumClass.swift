//
//  EunmClass.swift
//  IOS_Project_OnlineDating
//
//  Created by 黃泰銘 on 2020/5/26.
//  Copyright © 2020 黃泰銘. All rights reserved.
//

import SwiftUI

class ENUM_CLASS {
    
    public enum SEX {
        case MALE
        case FEMALE
        case UNDEFINED
    }
    
    public enum PAGES{
        case AUTH_PAGE
        case INFO_PAGE
        case SWIPE_PAGE
        case CHAT_PAGE
        case MSGLIST_PAGE
    }
    
    public enum SIGN_UP_PAGES{
        case EMAIL_PAGE
        case PASSWORD_PAGE
        case INFO_PAGE
        case INIT_PAGE
    }
}
