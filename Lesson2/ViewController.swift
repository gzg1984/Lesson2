//
//  ViewController.swift
//  Lesson2
//
//  Created by 高志刚 on 2018/12/9.
//  Copyright © 2018年 高志刚. All rights reserved.
//

import UIKit
var Teststr = "Hello, playground"

class ViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = Teststr
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view

        // Do any additional setup after loading the view, typically from a nib.
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}
