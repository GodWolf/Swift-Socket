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
            
            //获取内容长度
            guard let lengthMsg = self.client.read(4) else{
                isClientConnect = false
                delegate?.disConnectClient(self)
                print("断开")

                continue
            }
            var length : Int = 0
            let lengthData = Data(bytes: lengthMsg, count: 4)
            (lengthData as NSData).getBytes(&length, length: 4)
            
            //获取内容类型
            guard let typeMsg = self.client.read(2) else{
                continue
            }
            var type : Int = 0
            let typeData = Data(bytes: typeMsg, count: 2)
            (typeData as NSData).getBytes(&type, length: 2)
            
            //获取内容
            guard let contentMsg = self.client.read(length) else {
                continue
            }
            let contentData = Data(bytes: contentMsg, count: length)
            
            let totalData = lengthData + typeData + contentData
            delegate?.sentMsg(totalData)
        }
    
    }

}
