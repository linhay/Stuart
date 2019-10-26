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
       let framework = Bundle(path: "/System/Library/PrivateFrameworks/ReminderKitUI.framework")?.load()
        print(framework)
        guard let insten = (NSClassFromString("REMReminderCreationViewController") as? UIViewController.Type)?.perform(Selector("new")) else {
            return
        }

        guard let vc = insten.takeRetainedValue() as? UIViewController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
        // present(vc, animated: true, completion: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

}

