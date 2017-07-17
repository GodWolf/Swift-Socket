//
//  ViewController.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/5.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var serverAddress: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    fileprivate var socket : SunSocket?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    @IBAction func connectServer(_ sender: UIButton) {
        
        guard serverAddress.text!.characters.count > 0 else {
            return
        }
        socket = SunSocket(addr: serverAddress.text!, port: 7878)
        socket?.delegate = self
        
        if socket!.connectServer() {
            socket!.readMessage()
            statusLabel.text = "连接成功"
            socket!.enterRoom()
        }
    }

    @IBAction func closeConnect(_ sender: UIButton) {
        
        socket!.leaveRoom()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        guard (textField.text?.characters.count)! > 0 else {
            return
        }
        socket!.sendTestMessage(contents: textField.text!)
        textField.text = ""
    }
}

extension ViewController : SunSocketProrocol {
    
    func didEnterRoom(user: UserInfo) {
        
        messageLabel.attributedText = SunSocketTextTool.getEnterOrLeaveText(true, userName: user.name)
    }
    
    func didLeaveRoom(user: UserInfo) {
        
        messageLabel.attributedText = SunSocketTextTool.getEnterOrLeaveText(false, userName: user.name)
    }
    
    func didReceiveTextMessage(textMessage: TextMessage) {
        
        messageLabel.text =  textMessage.user.name + textMessage.text
    }
    
    func didReceiveGiftMesssage(giftMessage: GiftMessage) {
        

    }
}



