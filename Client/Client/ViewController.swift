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
    fileprivate var isConnectServer : Bool = false
    
    fileprivate lazy var textFieldView : UIView = {
    
        let textFieldBgView = UIView(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 40))
        textFieldBgView.backgroundColor = UIColor.orange
        
        let sendBtn = UIButton(frame: CGRect(x:self.view.bounds.width-55, y: 5, width: 50, height: 30))
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        
        textFieldBgView.addSubview(sendBtn)
        textFieldBgView.addSubview(self.msgField)
        
        return textFieldBgView
    }()
    
    fileprivate lazy var msgField : UITextField = {
    
        let emotionBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        emotionBtn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        emotionBtn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        emotionBtn.addTarget(self, action: #selector(emotionBoardAction(_:)), for: .touchUpInside)
        
        let field = UITextField(frame: CGRect(x: 5, y: 5, width: self.view.bounds.width-70, height: 30))
        field.rightView = emotionBtn
        field.rightViewMode = .always
        field.backgroundColor = UIColor.white
        
        
        return field
    }()
    
    fileprivate lazy var emotionView : SunEmotionView = {
    
        let ev = SunEmotionView(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 200))
        
        return ev
    }()
    
    fileprivate var socket : SunSocket?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(textFieldView)
        
        emotionView.selectBlock = {[weak self] emotion in
            
            if emotion.emotionName == "delete-n"{
                self?.msgField.deleteBackward()
                return
            }
            
            guard let range = self?.msgField.selectedTextRange else {
                return
            }
            self?.msgField.replace(range, withText: emotion.emotionName)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if msgField.isFirstResponder {
            
            msgField.resignFirstResponder()
        }else{
        
            msgField.becomeFirstResponder()
        }
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
            isConnectServer = true
        }else{
        
            isConnectServer = false
        }
    }

    @IBAction func closeConnect(_ sender: UIButton) {
        
        socket!.leaveRoom()
        isConnectServer = false
    }
    
    @objc fileprivate func sendMessage(_ sender: UIButton) {
        
        guard (msgField.text?.characters.count)! > 0 else {
            return
        }
        if isConnectServer == true {
        
            socket!.sendTestMessage(contents: msgField.text!)
        }
        
        msgField.text = ""
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
        
        messageLabel.attributedText = SunSocketTextTool.getTextMessage(textMessage.user.name, contents: textMessage.text)
        
    }
    
    func didReceiveGiftMesssage(giftMessage: GiftMessage) {
        
        
    }
}

//MARK: 表情输入
extension ViewController {

    @objc fileprivate func emotionBoardAction(_ button : UIButton) {
    
        button.isSelected = !button.isSelected
        
        
        let range = msgField.selectedTextRange
        
        msgField.resignFirstResponder()
        msgField.inputView = (button.isSelected ? emotionView : nil)
        msgField.becomeFirstResponder()
        msgField.selectedTextRange = range
        
    }
}

//MARK: 键盘展示消失
extension ViewController {

    @objc fileprivate func keyboardFrameChange(_ notification : Notification) {
    
        let durtion = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
     
        var endY = endFrame.origin.y-textFieldView.bounds.height
        endY = ((endY == (view.bounds.height-textFieldView.bounds.height)) ? view.bounds.height : endY)
        UIView.animate(withDuration: durtion) { 
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            self.textFieldView.frame.origin.y = endY
        }
    }
}



