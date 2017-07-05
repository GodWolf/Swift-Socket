//
//  ClientManager.swift
//  Servers
//
//  Created by 孙兴祥 on 2017/7/4.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import Cocoa

protocol ClientManagerProtocol : class {
    
    /// 失去连接
    func disConnectClient(_ client : ClientManager)
    ///发送消息
    func sentMsg(_ data : Data)
}

class ClientManager: NSObject {

    var client : TCPClient
    
    weak var delegate : ClientManagerProtocol?
    
    fileprivate var isClientConnect : Bool = false
    
    init(client : TCPClient) {
        self.client = client
        super.init()
        
    }
    
    //MARK: 开始监听读取数据
    func startReading() {
        isClientConnect = true
        while isClientConnect {
            
            
            if let lengthMsg = client.read(5) {//如果断开连接会自动失败
                
                let lengthData = Data(bytes: lengthMsg, count: 5)
                let content = String(bytes: lengthData, encoding: .utf8)!
                print(content)
                
            }else{
            
                isClientConnect = false
                print("失败")
                client.close()
            }
        }
        
    }
    
}
