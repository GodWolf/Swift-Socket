//
//  ViewController.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/5.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    fileprivate lazy var socket : SunSocket = SunSocket(addr: "172.16.105.134", port: 7878)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        socket.delegate = self;
    }


    @IBAction func connectServer(_ sender: UIButton) {
        
        if socket.connectServer() {
            socket.readMessage()
            statusLabel.text = "连接成功"
            socket.enterRoom()
        }
    }

    @IBAction func closeConnect(_ sender: UIButton) {
        
        socket.leaveRoom()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        guard (textField.text?.characters.count)! > 0 else {
            return
        }
        socket.sendTestMessage(contents: textField.text!)
        textField.text = ""
    }
}

extension ViewController : SunSocketProrocol {
    
    func didReceiveTextMessage(textMessage: TextMessage) {
        
        messageLabel.text =  textMessage.user.name + textMessage.text
    }
    func didEnterRoom(user: UserInfo) {
        messageLabel.text = user.name + "进入"
    }
    
    func didLeaveRoom(user: UserInfo) {
        messageLabel.text = user.name + "离开"
    }
}

