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
import Toast_Swift

final class GatewayViewController : UIViewController{
    private var host : ErrorTextField!
    private var vendorThingId: ErrorTextField!
    private var thingID: ErrorTextField!
    private let yPos : (CGFloat,CGFloat,CGFloat,CGFloat) = (70,120,180,250)

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
        let label = MaterialLabel(frame: CGRectMake(40, yPos.0, view.bounds.width - 80, 30))
        label.text = "Gateway"
        label.font = MaterialFont.boldSystemFontWithSize(20)

        self.view.addSubview(label)

        host = ErrorTextField(frame: CGRectMake(40, yPos.1, view.bounds.width - 80, 32))
        host.placeholder = "Host"
        host.text = "10.5.2.132:4001"
        host.placeholderColor = MaterialColor.amber.darken4
        host.placeholderActiveColor = MaterialColor.pink.base
        host.dividerColor = MaterialColor.cyan.base
        host.enabled = false
        view.addSubview(host)

    }
    override func viewDidAppear(animated: Bool) {
        self.parentViewController?.view?.makeToastActivity(.Center)
        defer{
            self.parentViewController?.view.hideToastActivity()
        }
        guard let savedGatewayAPI = try? GatewayAPI.loadWithStoredInstance() else {
            self.performSegueWithIdentifier("showWizard", sender: nil)
            return
        }
        savedGatewayAPI?.onboardGateway({ (gateway, error) in

            print(savedGatewayAPI?.gatewayAddress.baseURL?.absoluteString)
            self.vendorThingId.text = gateway?.vendorThingID
            self.thingID.text = gateway?.thingID
            self.host.text = savedGatewayAPI?.gatewayAddress.absoluteString
        })

    }


    /// Prepares the email TextField.
    private func prepareVendorThingIDField() {
        vendorThingId = ErrorTextField(frame: CGRectMake(40, yPos.2, view.bounds.width - 80, 32))
        vendorThingId.placeholder = "Vendor Thing ID"


        vendorThingId.enableClearIconButton = true
        vendorThingId.enabled = false

        vendorThingId.placeholderColor = MaterialColor.amber.darken4
        vendorThingId.placeholderActiveColor = MaterialColor.pink.base
        vendorThingId.dividerColor = MaterialColor.cyan.base

        view.addSubview(vendorThingId)
    }

    /// Prepares the password TextField.
    private func prepareThingIDField() {
        thingID = ErrorTextField()
        thingID.placeholder = "ThingID"

        thingID.enabled = false
        // Setting the visibilityFlatButton color.
        thingID.placeholderColor = MaterialColor.amber.darken4
        thingID.placeholderActiveColor = MaterialColor.pink.base
        thingID.dividerColor = MaterialColor.cyan.base
        // Size the TextField to the maximum width, less 40 pixels on either side
        // with a top margin of 200 pixels.
        view.layout(thingID).top(yPos.3).horizontally(left: 40, right: 40)
    }


}