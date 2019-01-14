//
//  ViewController.swift
//  Lesson2
//
//  Created by 高志刚 on 2018/12/9.
//  Copyright © 2018年 高志刚. All rights reserved.
//

import UIKit
import SwiftSocket

//服务器端口
var StaticServerPort:Int32 = 8888
var StaticServerIP:String = "192.168.0.119"

class ViewController: UIViewController {
    
    @IBOutlet weak var ConnectionMsg: UITextView!
    /*Connect to server */
    func processClientSocket(){
        socketClient=TCPClient(address: StaticServerIP, port: StaticServerPort)
        
        DispatchQueue.global(qos: .background).async {
            //用于读取并解析服务端发来的消息
            //  func readmsg()->[String:Any]?{
            //read 4 byte int as type
            func readmsg()->String?{
                
                
                if let data=self.socketClient!.read(100,timeout: 5){
                    return String(bytes: data, encoding: .utf8)!
                    
                    
                    
                    /*self.textView.text = self.textView.text
                     //     + "\n" */
                    
                    /*
                     let msgi=["cmd":"msg","content":data] as [String : Any]
                     return msgi as? [String:Any]
                     */
                    /*
                     
                     if data.count==4{
                     let ndata=NSData(bytes: data, length: data.count)
                     var len:Int32=0
                     ndata.getBytes(&len, length: data.count)
                     if let buff=self.socketClient!.read(Int(len)){
                     let msgd = Data(bytes: buff, count: buff.count)
                     if let msgi = try? JSONSerialization.jsonObject(with: msgd,
                     options: .mutableContainers) {
                     return msgi as? [String:Any]
                     }
                     }
                     }
                     */
                }
                return nil
            }
            while true {
                Thread.sleep(forTimeInterval: 1.0)
                //连接服务器
                self.alert(msg: "Trying To Connect to "+StaticServerIP + "\n", after: {})

                switch self.socketClient!.connect(timeout: 5) {
                case .success:
                    DispatchQueue.main.async {
                        self.alert(msg: "connect success \n", after: {
                        })
                    }
                    
                    //发送用户名给服务器（这里使用随机生成的）
                    let msgtosend=["cmd":"nickname","nickname":"游客\(Int(arc4random()%1000))"]
                    self.sendMessage(msgtosend: msgtosend)
                    
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
        
        //启动服务器
        //socketServer = MyTcpSocketServer()
        //socketServer!.start()
        
        //初始化客户端，并连接服务器
        processClientSocket()
    }
    
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    //socket服务端封装类对象
    var socketServer:MyTcpSocketServer?
    //socket客户端类对象
    var socketClient:TCPClient?
    
    
    
    
    
    //“发送消息”按钮点击
    @IBAction func sendMsg(_ sender: AnyObject) {
        let content=textFiled.text!
        let message=["cmd":"msg","content":content]
        self.sendMessage(msgtosend: message)
        textFiled.text=nil
    }
    
    //发送消息
    func sendMessage(msgtosend:[String:String]){
        let msgdata=try? JSONSerialization.data(withJSONObject: msgtosend,
                                                options: .prettyPrinted)
        var len:Int32=Int32(msgdata!.count)
        let data = Data(bytes: &len, count: 4)
        _ = self.socketClient!.send(data: data)
        _ = self.socketClient!.send(data:msgdata!)
    }
    
    //处理服务器返回的消息
    //func processMessage(msg:[String:Any]){
    func processMessage(msg:String){
        
        /*
         let cmd:String=msg["cmd"] as! String
         switch(cmd){
         case "msg":
         */
        self.textView.text = self.textView.text + msg
        let nsra:NSRange = NSMakeRange((self.textView.text.lengthOfBytes(using: String.Encoding.utf8))-1, 1)
        self.textView.scrollRangeToVisible(nsra)
        
        //        (msg["from"] as! String) + ": " + (msg["content"] as! String) + "\n"
        /*
         default:
         print(msg)
         */
        // }
    }
    
    //弹出消息框
    func alert(msg:String,after:()->(Void)){
        /*
         let alertController = UIAlertController(title: "",
         message: msg,
         preferredStyle: .alert)
         self.present(alertController, animated: true, completion: nil)
         
         //1.5秒后自动消失
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
         alertController.dismiss(animated: false, completion: nil)
         }
         */
        self.ConnectionMsg.text = self.ConnectionMsg.text + msg + "\n"
        let nsra:NSRange = NSMakeRange((self.ConnectionMsg.text.lengthOfBytes(using: String.Encoding.utf8))-1, 1)
        self.ConnectionMsg.scrollRangeToVisible(nsra)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
