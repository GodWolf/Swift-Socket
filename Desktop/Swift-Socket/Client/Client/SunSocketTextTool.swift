//
//  SunSocketTextTool.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/17.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//


import UIKit

class SunSocketTextTool: NSObject {
    
    ///获取进入离开房间的富文本
    static func getEnterOrLeaveText(_ isEnter : Bool, userName : String) -> NSMutableAttributedString {
    
        let text = userName + (isEnter == true ? " 进入房间":" 离开房间")
        let attrText = NSMutableAttributedString(string: text)
        
        attrText.addAttributes([NSForegroundColorAttributeName:UIColor.orange], range: NSRange(location: 0, length: userName.characters.count))
        
        return attrText
    }

}
