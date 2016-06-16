//
//  ViewController.swift
//  gateway
//
//  Created by syahRiza on 6/15/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var container: UIView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToPrev(sender: AnyObject){
        Manager.SharedManager.prevVC()
    }

    @IBAction func goToNext(sender: AnyObject){
        Manager.SharedManager.nextVC()

    }
}

