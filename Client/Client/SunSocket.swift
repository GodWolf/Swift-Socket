//
//  SunSocket.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/5.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

protocol SunSocketProrocol : class {
    
    ///进入房间
    func didEnterRoom(user : UserInfo)
    ///离开房间
    func didLeaveRoom(user : UserInfo)
    ///收到文本消息
    func didReceiveTextMessage(textMessage : TextMessage)
    ///收到礼物消息
    func didReceiveGiftMesssage(giftMessage : GiftMessage)
}

class SunSocket: NSObject {
    
    fileprivate var client : TCPClient
    fileprivate var user : UserInfo.Builder
    fileprivate var isConnected : Bool = false
    weak var delegate : SunSocketProrocol?
    init(addr: String, port: Int) {
        
        client = TCPClient(addr: addr, port: port)
        user = UserInfo.Builder()
        user.name = "mac client"
//        user.name = "iphone client"
        user.level = Int64(arc4random_uniform(20)+1)
    }

}


extension SunSocket {
    
    //MARK: 连接服务区
    func connectServer() -> Bool {
    
        return client.connect(timeout: 5).0
    }
    
    //MARK: 读取消息
    func readMessage() {
        
        self.isConnected = true
        DispatchQueue.global().async {
            
            while self.isConnected == true {
                
                //获取内容长度
                guard let lengthMsg = self.client.read(4) else{
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
                
                self.handleMessage(contentData, type: type)
                
            }

        }
    }
    
    //0进入，1离开，2文本，3礼物
    
    //MARK: 进入房间
    func enterRoom() {
        
        let message = try! user.build()
        sendMessage(data: message.data(), type: 0)
    }
    
    //MARK: 离开房间
    func leaveRoom() {
        
        isConnected = false
        let message = try! user.build()
        sendMessage(data: message.data(), type: 1)
        client.close()
    }
    
    //MARK: 发送文本消息
    func sendTestMessage(contents : String){
        
        let content = TextMessage.Builder()
        content.user = try! user.build()
        content.text = contents
        
        let message = try! content.build()
        sendMessage(data: message.data(), type: 2)
    }
    
    //MARK: 发送礼物
    func sentGiftMessage(giftName : String, giftUrl : String, giftCount : Int){
        
        let content = GiftMessage.Builder()
        content.user = try! user.build()
        content.giftname = giftName
        content.giftUrl = giftUrl
        content.giftCount = "\(giftCount)"
        
        let message = try! content.build()
        sendMessage(data: message.data(), type: 3)
    }
    
    ///发送消息
    fileprivate func sendMessage(data : Data,type : Int) {
        
        
        var length = data.count
        let lengthData : Data = Data(bytes: &(length), count: 4)
        
        var tempType = type
        let typeData : Data = Data(bytes: &(tempType), count: 2)
        
        let totalData = lengthData + typeData + data
        
        client.send(data: totalData)
    }
    
}

extension SunSocket {
    
    fileprivate func handleMessage(_ data : Data,type : Int) {
        
        DispatchQueue.main.async {
            
            switch type {
            case 0:
                let person = try! UserInfo.parseFrom(data: data)
                self.delegate?.didEnterRoom(user: person)
            case 1:
                let person = try! UserInfo.parseFrom(data: data)
                self.delegate?.didLeaveRoom(user: person)
            case 2:
                let textMessage = try! TextMessage.parseFrom(data: data)
                self.delegate?.didReceiveTextMessage(textMessage: textMessage)
            case 3:
                let giftMessage = try! GiftMessage.parseFrom(data: data)
                self.delegate?.didReceiveGiftMesssage(giftMessage: giftMessage)
            default: break
                
            }
        }
    }
}
