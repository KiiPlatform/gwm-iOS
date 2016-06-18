//
//  GatewayConnectViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/16/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material

final class GatewayConnectViewController : WizardVC {

    private var ipField : ErrorTextField!
    private var portField : ErrorTextField!
    private var emailField: ErrorTextField!
    private var passwordField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Connect to Gateway"
        prepareView()
        prepareIPField()
        prepareEmailField()
        preparePasswordField()

    }

    /// Programmatic update for the textField as it rotates.
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        emailField.width = view.bounds.height - 80
    }

    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    private func prepareIPField() {
        ipField = ErrorTextField(frame: CGRectMake(40, 90, view.bounds.width - 80, 32))
        ipField.placeholder = "IP Address"

        ipField.enableClearIconButton = true
        ipField.delegate = self

        ipField.placeholderColor = MaterialColor.amber.darken4
        ipField.placeholderActiveColor = MaterialColor.pink.base
        ipField.dividerColor = MaterialColor.cyan.base

        view.addSubview(ipField)

        portField = ErrorTextField(frame: CGRectMake(40, 160, view.bounds.width - 80, 32))
        portField.placeholder = "Port Number"

        portField.enableClearIconButton = true
        portField.delegate = self

        portField.placeholderColor = MaterialColor.amber.darken4
        portField.placeholderActiveColor = MaterialColor.pink.base
        portField.dividerColor = MaterialColor.cyan.base

        view.addSubview(portField)
    }



    /// Prepares the email TextField.
    private func prepareEmailField() {
        emailField = ErrorTextField(frame: CGRectMake(40, 250, view.bounds.width - 80, 32))
        emailField.placeholder = "Username"

        emailField.enableClearIconButton = true
        emailField.delegate = self

        emailField.placeholderColor = MaterialColor.amber.darken4
        emailField.placeholderActiveColor = MaterialColor.pink.base
        emailField.dividerColor = MaterialColor.cyan.base

        view.addSubview(emailField)
    }

    /// Prepares the password TextField.
    private func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Password"

        passwordField.clearButtonMode = .WhileEditing
        passwordField.enableVisibilityIconButton = true

        // Setting the visibilityFlatButton color.
        passwordField.visibilityIconButton?.tintColor = MaterialColor.green.base.colorWithAlphaComponent(passwordField.secureTextEntry ? 0.38 : 0.54)

        // Size the TextField to the maximum width, less 40 pixels on either side
        // with a top margin of 200 pixels.
        view.layout(passwordField).top(310).horizontally(left: 40, right: 40)
    }
}
