//
//  ViewController.swift
//  Stuart
//
//  Created by linhey on 10/08/2019.
//  Copyright (c) 2019 linhey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

 

    override func viewDidLoad() {
        super.viewDidLoad()

        OBJC.Class(name: "ViewController")?.methods.forEach { (item) in
            print(item)
        }

        OBJC.Class.load("/System/Library/PrivateFrameworks/ReminderKitUI.framework")
        guard let vc = OBJC.Class(name: "REMReminderCreationViewController")?.new() as? UIViewController else {
            return
        }

        navigationController?.pushViewController(vc, animated: true)
        // present(vc, animated: true, completion: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

}

