//
//  ViewController.swift
//  Servers
//
//  Created by 孙兴祥 on 2017/7/4.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var statusLabel: NSTextField!
    
    fileprivate lazy var serverManager : ServersManager = ServersManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func openServerAction(_ sender: NSButton) {
        serverManager.openServers()
        statusLabel.stringValue = "服务器开启"
    }

    @IBAction func closeSeversAction(_ sender: NSButton) {
        serverManager.closeServers()
        statusLabel.stringValue = "服务器关闭"
    }
}

