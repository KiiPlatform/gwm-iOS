//
//  GatewayPasswordViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/17/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material
import ThingIFSDK
import Toast_Swift

final class GatewayPasswordViewController : WizardVC {

    private var passwordField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Onboard"

        Manager.SharedManager.nextAction = { [weak self]
            completion in
            guard let password = self?.passwordField.text else {
                completion(false)
                return
            }
            guard let gatewayApi = try? GatewayAPI.loadWithStoredInstance() else {
                completion(false)
                return
            }

            guard let thingIfApi = try? ThingIFAPI.loadWithStoredInstance() else {
                completion(false)
                return
            }
            var style = ToastStyle()
            style.backgroundColor = MaterialColor.blue.accent2.colorWithAlphaComponent(0.5)

            gatewayApi?.onboardGateway({ (gateway, error) in
                let success = error == nil

                if !success {
                    style.messageColor = MaterialColor.red.accent3
                    self?.parentViewController?.view?.makeToast("error : \(error)", duration: 3, position: .Center,style: style)
                    completion(false)
                    return
                }

                let api = thingIfApi?.copyWithTarget(gateway!)
                api?.onboard((gateway?.thingID)!, thingPassword: password, completionHandler: { (_, error) in
                    let success = error == nil

                    if success {
                        self?.parentViewController?.view?.makeToast("Sign in Succeded", duration: 1, position: .Bottom,style: style)
                    }else {
                        style.messageColor = MaterialColor.red.accent3
                        self?.parentViewController?.view?.makeToast("error \(error)", duration: 3, position: .Center,style: style)
                    }
                    
                    completion(success)

                })


            })


        }
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