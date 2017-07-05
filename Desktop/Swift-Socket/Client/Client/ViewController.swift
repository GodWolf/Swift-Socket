//
//  ViewController.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/5.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate lazy var socket : SunSocket = SunSocket(addr: "172.16.105.134", port: 7878)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        socket.connectServer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        socket.sendTestMessage(contents: "hello")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

