//
//  ViewController.swift
//  iosrealcom
//
//  Created by lakshmana on 01/03/18.
//  Copyright © 2018 nearhop. All rights reserved.
//

import UIKit
import SwiftWebSocket

class ViewController: UIViewController {

 
    @IBOutlet weak var messagesText: UILabel!
    @IBOutlet weak var sendMessage: UITextField!
    @IBOutlet weak var sendMe: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let ctap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(ctap)
        echoTest();
    }
        // Do any additional setup after loading the view, typically from a nib.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func echoTest(){
        var messageNum = 0
        let ws = WebSocket("ws://192.168.1.4:5857")
        let send : ()->() = {
            messageNum += 1
            let msg = "\(messageNum): \(NSDate().description)"
            print("send: \(msg)")
            ws.send(msg)
        }
        ws.event.open = {
            print("opened")
            send()
        }
        ws.event.close = { code, reason, clean in
            print("close")
        }
        ws.event.error = { error in
            print("error \(error)")
        }
        ws.event.message = { message in
            if let text = message as? String {
                print("recv: \(text)")
                if messageNum == 10 {
                    ws.close()
                } else {
                    send()
                }
            }
        }
    }
    
    

}

