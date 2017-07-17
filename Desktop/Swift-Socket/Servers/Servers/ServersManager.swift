//
//  ServersManager.swift
//  Servers
//
//  Created by 孙兴祥 on 2017/7/4.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import Cocoa

class ServersManager: NSObject {
    
    fileprivate lazy var servers : TCPServer = TCPServer(addr: "0.0.0.0", port: 7878)
    fileprivate lazy var clients : [ClientManager] = [ClientManager]()
    fileprivate lazy var isRunning : Bool = false
    
    override init() {
        super.init()
        
    }
}

//MARK: 开启关闭
extension ServersManager {
    
    func openServers() {
        //监听
        servers.listen()
        isRunning = true
        
        DispatchQueue.global().async {
            
            while self.isRunning == true {
                if let client = self.servers.accept() {
                    
                    DispatchQueue.global().async {
                        self.handleClient(client: client)
                    }
                    
                }
            }
        }
    }
    
    func closeServers() {
        
        isRunning = false
        clients.removeAll()
        
    }
}

extension ServersManager {
    
    //处理消息
    fileprivate func handleClient(client : TCPClient) {
        
        let clientMgr = ClientManager(client: client)
        clientMgr.delegate = self
        self.clients.append(clientMgr)
        clientMgr.startReading()
    }
}

extension ServersManager : ClientManagerProtocol {
    
    ///断开连接
    func disConnectClient(_ client: ClientManager) {
        
        guard let index = clients.index(of: client) else {
            return
        }
        clients.remove(at: index)
    }
    
    ///进入房间，离开房间，发送文本消息、发送礼物消息
    func sentMsg(_ data : Data) {
        
        for clientMgr in clients {
            clientMgr.client.send(data: data)
        }
    }

}

