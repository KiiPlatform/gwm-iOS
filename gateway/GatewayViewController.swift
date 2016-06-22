//
//  GatewayViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/20/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material
import ThingIFSDK

final class GatewayViewController : UIViewController{
    private var host : ErrorTextField!
    private var vendorThingId: ErrorTextField!
    private var thingID: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Connected to Gateway"
        prepareView()
        prepareIPField()
        prepareVendorThingIDField()
        prepareThingIDField()

    }

    /// Programmatic update for the textField as it rotates.
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        vendorThingId.width = view.bounds.height - 80
    }

    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    private func prepareIPField() {
        let label = MaterialLabel(frame: CGRectMake(40, 70, view.bounds.width - 80, 30))
        label.text = "Gateway"
        label.font = MaterialFont.boldSystemFontWithSize(20)

        self.view.addSubview(label)

        host = ErrorTextField(frame: CGRectMake(40, 120, view.bounds.width - 80, 32))
        host.placeholder = "Host"
        host.text = "10.5.2.132:4001"
        host.placeholderColor = MaterialColor.amber.darken4
        host.placeholderActiveColor = MaterialColor.pink.base
        host.dividerColor = MaterialColor.cyan.base
        host.enabled = false
        view.addSubview(host)

    }
    override func viewDidAppear(animated: Bool) {
        guard let savedIoTAPI = try? ThingIFAPI.loadWithStoredInstance() else {
            self.performSegueWithIdentifier("showWizard", sender: nil)
            return
        }
        print(savedIoTAPI.debugDescription)

    }


    /// Prepares the email TextField.
    private func prepareVendorThingIDField() {
        vendorThingId = ErrorTextField(frame: CGRectMake(40, 250, view.bounds.width - 80, 32))
        vendorThingId.placeholder = "Vendor Thing ID"
        vendorThingId.text = "dummy vendor thing is"

        vendorThingId.enableClearIconButton = true
        vendorThingId.enabled = false

        vendorThingId.placeholderColor = MaterialColor.amber.darken4
        vendorThingId.placeholderActiveColor = MaterialColor.pink.base
        vendorThingId.dividerColor = MaterialColor.cyan.base

        view.addSubview(vendorThingId)
    }

    /// Prepares the password TextField.
    private func prepareThingIDField() {
        thingID = TextField()
        thingID.placeholder = "ThingID"
        thingID.text = "dummy Thing ID"
        thingID.enabled = false
        // Setting the visibilityFlatButton color.
        thingID.visibilityIconButton?.tintColor = MaterialColor.green.base.colorWithAlphaComponent(thingID.secureTextEntry ? 0.38 : 0.54)

        // Size the TextField to the maximum width, less 40 pixels on either side
        // with a top margin of 200 pixels.
        view.layout(thingID).top(310).horizontally(left: 40, right: 40)
    }


}