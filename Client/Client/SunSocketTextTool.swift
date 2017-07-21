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
    
    static func getTextMessage(_ userName : String,contents : String) -> NSMutableAttributedString {
    
        let nameAttr = NSMutableAttributedString(string: userName+" ", attributes: [NSForegroundColorAttributeName:UIColor.orange])
        
        let contentAttr = NSMutableAttributedString(string: contents, attributes: [:])
        
        guard let regx = try? NSRegularExpression(pattern: "\\[.*?\\]", options: []) else {
            
            nameAttr.append(contentAttr)
            return nameAttr
        }
        
        let results : [NSTextCheckingResult] = regx.matches(in: contents, options: [], range: NSMakeRange(0, contents.characters.count))
        
        for result in results.reversed() {
        
            let emotionName = (contents as NSString).substring(with: result.range)
            
            guard let image = UIImage(named: emotionName) else {
                continue
            }
            let height = UIFont.systemFont(ofSize: 17).lineHeight
            let emotion = NSTextAttachment()
            emotion.image = image
            emotion.bounds = CGRect(x: 0, y: -3, width: height, height: height)
            
            contentAttr.replaceCharacters(in: result.range, with: NSAttributedString(attachment: emotion))
        }
        
        nameAttr.append(contentAttr)
        return nameAttr
    }

}
