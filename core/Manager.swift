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
typealias ButtonProperties = (enabled : Bool, title : String?)
let DEFAULT_NEXT_BUTTON = ButtonProperties(true,"Next")
let DEFAULT_PREV_BUTTON = ButtonProperties(true,"Back")


class Manager {
    static let SharedManager = Manager()
    weak var currentVC : UIViewController!
    private init(){

    }
    lazy var appName : String! = { return NSUserDefaults.standardUserDefaults().stringForKey(APP_NAME) }()
    lazy var appID : String! = { return NSUserDefaults.standardUserDefaults().stringForKey(APP_ID) }()
    lazy var appKey : String! = { return NSUserDefaults.standardUserDefaults().stringForKey(APP_KEY) }()
    var prevAction : (() -> ()) = { }
    var nextAction : (((Bool) -> ()) -> ()) = { completion in  completion(true)}
    var childWillLoadedAction : ((prevButton: ButtonProperties, nextButton : ButtonProperties ) ->()) = { (_,_) in }


    func nextVC(){
        self.nextAction { (succeeded) in
            if succeeded {
                if self.currentVC.canPerformSegueWithIdentifier("next") {
                    self.currentVC.performSegueWithIdentifier("next", sender: nil)
                }else {
                    self.currentVC.dismissViewControllerAnimated(true, completion: {

                    })
                }
            }
        }

    }
    func prevVC(){
        self.prevAction()

        self.currentVC.navigationController?.popViewControllerAnimated(true)

    }
    
}
