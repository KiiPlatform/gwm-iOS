//
//  GatewayPasswordViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/17/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material

final class GatewayPasswordViewController : WizardVC {

    private var passwordField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Onboard"
        prepareView()
        preparePasswordField()
    }

    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }

    /// Prepares the password TextField.
    private func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Gateway Password"
        passwordField.text = "password"
        passwordField.clearButtonMode = .WhileEditing
        passwordField.enableVisibilityIconButton = true
        passwordField.visibilityIconButton?.tintColor = MaterialColor.green.base.colorWithAlphaComponent(passwordField.secureTextEntry ? 0.38 : 0.54)
        view.layout(passwordField).top(100).horizontally(left: 40, right: 40)
    }
}