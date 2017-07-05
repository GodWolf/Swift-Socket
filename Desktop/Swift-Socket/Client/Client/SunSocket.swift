//
//  SunSocket.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/5.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

class SunSocket: NSObject {
    
    fileprivate var client : TCPClient
    init(addr: String, port: Int) {
        
        client = TCPClient(addr: addr, port: port)
    }

}


extension SunSocket {
    
    //MARK: 连接服务区
    func connectServer() -> Bool {
    
        return client.connect(timeout: 5).0
    }
    
    func sendTestMessage(contents : String){
        
        let data : Data = contents.data(using: .utf8)!
        print(data.count)
        client.send(data: data)
    }
}
