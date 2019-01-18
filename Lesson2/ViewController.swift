//
//  ViewController.swift
//  Lesson2
//
//  Created by 高志刚 on 2018/12/9.
//  Copyright © 2018年 高志刚. All rights reserved.
//

import UIKit
import SwiftSocket
import AdSupport


/* Server port.
 should get this port from Nameservice
 */
var StaticServerPort:Int32 = 8888
var StaticServerIP:String = "192.168.0.119"

class ViewController: UIViewController {
    
    /*Connect to server */
    func processClientSocket(){
        socketClient=TCPClient(address: StaticServerIP, port: StaticServerPort)
        
        DispatchQueue.global(qos: .background).async {
            /* Read Any thing from service
            The server only send Ray data*/
            func readmsg()->String?{
                if let data=self.socketClient!.read(100,timeout: 5){
                    return String(bytes: data, encoding: .utf8)!
                }
                return nil
            }
            while true {
                Thread.sleep(forTimeInterval: 1.0)
                self.alert(msg: "Trying To Connect to "+StaticServerIP + "\n", after: {})

                switch self.socketClient!.connect(timeout: 5) {
                case .success:
                    DispatchQueue.main.async {
                        self.alert(msg: "connect success \n", after: {
                        })
                    }
                    
                    /* get advertising id */
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString

                    let msgtosend=idfa
                    var len:Int32=Int32(msgtosend.count)
                    let data = Data(bytes: &len, count: 4)
                    _ = self.socketClient!.send(data: data)

                    
                    
                    //不断接收服务器发来的消息
                    while true{
                        if let msg=readmsg(){
                            DispatchQueue.main.async {
                                self.processMessage(msg: msg)
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.alert(msg: "Read Message Error\n",after: {})
                            }
                            break
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.alert(msg: error.localizedDescription,after: {})
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processClientSocket()
    }
    
    @IBOutlet weak var textView: UITextView!
    
    //socket服务端封装类对象
    var socketServer:MyTcpSocketServer?
    //socket客户端类对象
    var socketClient:TCPClient?
    
    
    //处理服务器返回的消息
    func processMessage(msg:String) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"// 自定义时间格式
        let time = dateformatter.string(from: Date())
        
        self.alert(msg: time + "\n" + msg, after: {})

    }
    
    //弹出消息框
    func alert(msg:String,after:()->(Void)){
        self.textView.text = self.textView.text + msg + "\n"
        let nsra:NSRange = NSMakeRange((self.textView.text.lengthOfBytes(using: String.Encoding.utf8))-1, 1)
        self.textView.scrollRangeToVisible(nsra)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
