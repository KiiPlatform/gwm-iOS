//
//  MainViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/15/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Material



final class MainViewController: WizardVC {

    private var nameField: TextField!
    private var appIDField: ErrorTextField!
    private var appKeyField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareKiiSite()
        prepareAppIDField()
        prepareAppKeyField()

    }

    /// Programmatic update for the textField as it rotates.
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        appIDField.width = view.bounds.height - 80
    }

    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }



    /// Handle the resign responder button.
    internal func handleResignResponderButton() {
        nameField?.resignFirstResponder()
        appIDField?.resignFirstResponder()
        appKeyField?.resignFirstResponder()

    }

    /// Prepares the name TextField.
    private func prepareKiiSite() {

        let siteLabel = MaterialLabel()
        siteLabel.text = "Kii Site :"
        siteLabel.textAlignment = .Center
        view.layout(siteLabel).top(100).horizontally(left: 40, right: 40)
        let segment = UISegmentedControl(items: ["US","JP","CN","SG","EU"])
        segment.selectedSegmentIndex = 1

        view.layout(segment).top(140).horizontally(left: 40, right: 40)
    }

    /// Prepares the email TextField.
    private func prepareAppIDField() {
        appIDField = ErrorTextField(frame: CGRectMake(40, 220, view.bounds.width - 80, 32))
        appIDField.text = Manager.SharedManager.appID
        appIDField.placeholder = "AppID"
        appIDField.detail = "Your \(Manager.SharedManager.appName) App ID"
        appIDField.enableClearIconButton = true
        appIDField.delegate = self

        appIDField.placeholderColor = MaterialColor.amber.darken4
        appIDField.placeholderActiveColor = MaterialColor.pink.base
        appIDField.dividerColor = MaterialColor.cyan.base

        view.addSubview(appIDField)
    }

    /// Prepares the password TextField.
    private func prepareAppKeyField() {
        appKeyField = TextField()
        appKeyField.text = Manager.SharedManager.appKey
        appKeyField.placeholder = "App Key"
        appKeyField.detail = "Your \(Manager.SharedManager.appName) App Key"
        appKeyField.clearButtonMode = .WhileEditing
        appKeyField.enableVisibilityIconButton = true

        // Setting the visibilityFlatButton color.
        appKeyField.visibilityIconButton?.tintColor = MaterialColor.green.base.colorWithAlphaComponent(appKeyField.secureTextEntry ? 0.38 : 0.54)

        // Size the TextField to the maximum width, less 40 pixels on either side
        // with a top margin of 200 pixels.
        view.layout(appKeyField).top(300).horizontally(left: 40, right: 40)
    }

    /// Executed when the 'return' key is pressed when using the emailField.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.revealError = true
        return true
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        (textField as? ErrorTextField)?.revealError = false
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.revealError = false
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        (textField as? ErrorTextField)?.revealError = false
        return true
    }

    
}
