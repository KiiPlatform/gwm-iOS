//
//  LoginViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/16/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material
import Toast_Swift
import ThingIFSDK

final class LoginViewController : WizardVC {
    private var signUpSwitch: UISwitch!
    private var emailField: ErrorTextField!
    private var passwordField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign in"
        Manager.SharedManager.nextAction = { [weak self]
            completion in
            guard let email = self?.emailField.text else {
                completion(false)
                return
            }

            var style = ToastStyle()
            style.backgroundColor = MaterialColor.blue.accent2.colorWithAlphaComponent(0.5)
            if self?.emailField.text! == "" || self?.passwordField.text! == "" {
                style.messageColor = MaterialColor.red.accent3
                self?.parentViewController?.view?.makeToast("Invalid Input", duration: 1, position: .Bottom,style: style)
                completion(false)
                return

            }

            self?.parentViewController?.view?.makeToastActivity(.Center)
            let userBlock : KiiUserBlock = { (user, error) in
                self?.parentViewController?.view?.hideToastActivity()
                let success = error == nil
                if success {

                    self?.parentViewController?.view?.makeToast("Sign in Succeded", duration: 1, position: .Bottom,style: style)
                    self?.initThingIFAPI((user?.userID)!, accessToken: (user?.accessToken)!)

                }else {
                    style.messageColor = MaterialColor.red.accent3
                    self?.parentViewController?.view?.makeToast("error \(error!.description)", duration: 3, position: .Center,style: style)
                }

                completion(success)
            }
            if (self?.signUpSwitch)!.on {
                let user = KiiUser(emailAddress: email, andPassword: (self?.passwordField.text)!)
                user.performRegistrationWithBlock(userBlock)
            }else {
                KiiUser.authenticate(email, withPassword: (self?.passwordField.text)!, andBlock: userBlock)
            }


        }

        prepareView()
        prepareSwitch()
        prepareEmailField()
        preparePasswordField()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Manager.SharedManager.childWillLoadedAction(prevButton: DEFAULT_PREV_BUTTON, nextButton: ButtonProperties(true,"Sign in"))
    }
    override func viewWillDisappear(animated: Bool) {
        Manager.SharedManager.childWillLoadedAction(prevButton: DEFAULT_PREV_BUTTON, nextButton: DEFAULT_NEXT_BUTTON)
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
        signUpSwitch.on = false
        let placeholder = MaterialView(frame: CGRectMake(40, 240, view.bounds.width - 80, 32))
        let label = MaterialLabel()
        label.text = "New user :"
        placeholder.layout(label).top(5).horizontally(left: 0, right: 40)
        placeholder.layout(signUpSwitch).top(1).horizontally(left: 100, right: 40)

        view.addSubview(placeholder)
    }

    /// Prepares the email TextField.
    private func prepareEmailField() {
        let email = "owner@kii.com"

        emailField = ErrorTextField(frame: CGRectMake(40, 90, view.bounds.width - 80, 32))
        emailField.placeholder = "Email"
        emailField.text = email

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
        passwordField.text = "pass"
        passwordField.clearButtonMode = .WhileEditing
        passwordField.enableVisibilityIconButton = true

        // Setting the visibilityFlatButton color.
        passwordField.visibilityIconButton?.tintColor = MaterialColor.green.base.colorWithAlphaComponent(passwordField.secureTextEntry ? 0.38 : 0.54)
        
        // Size the TextField to the maximum width, less 40 pixels on either side
        // with a top margin of 200 pixels.
        view.layout(passwordField).top(160).horizontally(left: 40, right: 40)
    }

    // init ThingIFAPI after success to login/register as KiiUser
    private func initThingIFAPI(ownerID: String, accessToken: String) {
        let owner = Owner(typedID: TypedID(type: "user", id: ownerID), accessToken: accessToken)
        let appSite = Manager.SharedManager.appSite
        let kiiSite = Manager.kiiSiteMap[appSite]!.1
        let app = App(appID: Manager.SharedManager.appID, appKey: Manager.SharedManager.appKey, site: kiiSite)
        let api = ThingIFAPIBuilder(app: app, owner: owner).build()

        api.saveInstance()

    }

    
}