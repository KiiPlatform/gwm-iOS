//
//  Manager.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/15/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material
let APP_NAME = "APP_NAME"
let APP_KEY = "APP_KEY"
let APP_ID = "APP_ID"
class WizardVC: UIViewController, TextFieldDelegate {

    override func viewWillAppear(animated: Bool) {
        Manager.SharedManager.currentVC = self

    }
}
extension UIViewController {
    func canPerformSegueWithIdentifier(identifier: NSString) -> Bool {
        guard let templates:NSArray = self.valueForKey("storyboardSegueTemplates") as? NSArray else {
            return false
        }
        let predicate:NSPredicate = NSPredicate(format: "identifier=%@", identifier)

        let filteredtemplates = templates.filteredArrayUsingPredicate(predicate)
        return (filteredtemplates.count>0)
    }
}
class Manager {
    static let SharedManager = Manager()
    weak var currentVC : UIViewController!
    private init(){

    }
    lazy var appName : String! = { return NSUserDefaults.standardUserDefaults().stringForKey(APP_NAME) }()
    lazy var appID : String! = { return NSUserDefaults.standardUserDefaults().stringForKey(APP_ID) }()
    lazy var appKey : String! = { return NSUserDefaults.standardUserDefaults().stringForKey(APP_KEY) }()

    func nextVC(){
        if self.currentVC.canPerformSegueWithIdentifier("next") {
            self.currentVC.performSegueWithIdentifier("next", sender: nil)
        }
    }
    func prevVC(){
        self.currentVC.navigationController?.popViewControllerAnimated(true)
    }
    
}
