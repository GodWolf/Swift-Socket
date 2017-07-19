//
//  SunEmotionPackage.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/19.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

class SunEmotionPackage: NSObject {
    
    var emotions : [SunEmotionModel] = [SunEmotionModel]()
    init(_ bundleName : String) {
        
        guard let path = Bundle.main.path(forResource: bundleName, ofType: nil) else {
            return
        }
        guard let emotionArray = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        
        for str in emotionArray {
            emotions.append(SunEmotionModel(str))
        }
    }
    
    static func getEmotions() -> [SunEmotionPackage] {
        
        var emotions = [SunEmotionPackage]()
        emotions.append(SunEmotionPackage("QHNormalEmotionSort.plist"))
        emotions.append(SunEmotionPackage("QHSohuGifSort.plist"))
        return emotions
    }
}
