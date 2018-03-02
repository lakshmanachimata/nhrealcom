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

    var ws : WebSocket!
    @IBOutlet weak var messagesText: UILabel!
    @IBOutlet weak var sendMessage: UITextField!
    @IBOutlet weak var sendMe: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let ctap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(ctap)
        openWebSokcet();
        
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
    
    func openWebSokcet(){
        ws = WebSocket("ws://192.168.2.102:5857")
        ws.event.open = {
            print("opened")
            let when = DispatchTime.now() + 1
            DispatchQueue.global().asyncAfter(deadline: when) {
                self.sendMessage(msg : "Hi from iOS");
            }
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
            }
        }
    }
    func sendMessage(msg : String){
        ws.send(msg)
    }
}

