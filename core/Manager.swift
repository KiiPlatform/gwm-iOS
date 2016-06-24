//
//  Manager.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/15/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material
import ThingIFSDK
let APP_NAME = "APP_NAME"
let APP_KEY = "APP_KEY"
let APP_ID = "APP_ID"
let APP_SITE = "APP_SITE"
typealias ButtonProperties = (enabled : Bool, title : String?)
let DEFAULT_NEXT_BUTTON = ButtonProperties(true,"Next")
let DEFAULT_PREV_BUTTON = ButtonProperties(true,"Back")


class Manager {
    static let SharedManager = Manager()
    private var isProcessing = false

    weak var currentVC : UIViewController!
    private init(){

    }
    lazy var appName : String! = { return NSUserDefaults.standardUserDefaults().stringForKey(APP_NAME) }()
    lazy var appID : String! = { return NSUserDefaults.standardUserDefaults().stringForKey(APP_ID) }()
    lazy var appKey : String! = { return NSUserDefaults.standardUserDefaults().stringForKey(APP_KEY) }()
    lazy var appSite : String! = { return NSUserDefaults.standardUserDefaults().stringForKey(APP_SITE) }()
    static let kiiSiteMap : Dictionary <String,(KiiSite,Site)> = ["US":(KiiSite.US,Site.US),"JP":(KiiSite.JP,Site.JP),"CN":(KiiSite.CN,Site.CN3),"SG":(KiiSite.SG,Site.SG),"CN3":(KiiSite.CN3,Site.CN3)]

    var prevAction : (() -> ()) = { }
    var nextAction : (((Bool) -> ()) -> ()) = { completion in  completion(true)}
    var childWillLoadedAction : ((prevButton: ButtonProperties, nextButton : ButtonProperties ) ->()) = { (_,_) in }


    func nextVC(){
        if self.isProcessing {
            return
        }
        self.isProcessing = true

        self.nextAction { (succeeded) in
            self.isProcessing = false

            if succeeded {
                self.nextAction = { completion in  completion(true)}
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
