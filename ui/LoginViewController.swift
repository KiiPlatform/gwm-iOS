//
//  LoginViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/16/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material

final class LoginViewController : WizardVC {
    private var signUpSwitch: UISwitch!
    private var emailField: ErrorTextField!
    private var passwordField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign in"
        prepareView()
        prepareSwitch()
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

    /// Prepares the name TextField.
    private func prepareSwitch() {

        signUpSwitch = UISwitch()
        let placeholder = MaterialView(frame: CGRectMake(40, 240, view.bounds.width - 80, 32))
        let label = MaterialLabel()
        label.text = "New user :"
        placeholder.layout(label).top(5).horizontally(left: 0, right: 40)
        placeholder.layout(signUpSwitch).top(1).horizontally(left: 100, right: 40)

        // Size the TextField to the maximum width, less 40 pixels on either side
        // with a top margin of 40 pixels.
        view.addSubview(placeholder)
    }

    /// Prepares the email TextField.
    private func prepareEmailField() {
        emailField = ErrorTextField(frame: CGRectMake(40, 90, view.bounds.width - 80, 32))
        emailField.placeholder = "Username/Email"

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
        view.layout(passwordField).top(160).horizontally(left: 40, right: 40)
    }
}