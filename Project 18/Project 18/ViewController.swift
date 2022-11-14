//
//  ViewController.swift
//  Project 18
//
//  Created by Ákos Morvai on 2022. 05. 18..
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var valami = 23
        valami += 1
        assert(valami == 24, "It is not 24")
        print(1, 2, 3, separator: "+", terminator: "=6")
    }
}

