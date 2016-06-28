//
//  MainViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/15/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Material
import Toast_Swift


final class KiiInitialViewController: WizardVC {

    private let kiiSiteSegment = UISegmentedControl(items: ["US","JP","CN","SG","CN3"])
    private var appIDField: ErrorTextField!
    private var appKeyField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(Manager.SharedManager.appName) app Setting"
        prepareView()
        prepareKiiSite()
        prepareAppIDField()
        prepareAppKeyField()

    }

    override func viewDidAppear(animated: Bool) {
        Manager.SharedManager.nextAction = { [weak self]
            completion in
            guard let appID = self?.appIDField.text else {
                completion(false)
                return
            }
            var style = ToastStyle()
            style.backgroundColor = MaterialColor.blue.accent2.colorWithAlphaComponent(0.5)
            if self?.appIDField.text! == "" || self?.appKeyField.text! == "" {
                style.messageColor = MaterialColor.red.accent3
                self?.parentViewController?.view?.makeToast("Invalid Input", duration: 1, position: .Bottom,style: style)
                completion(false)
                return

            }
            Kii.beginWithID(appID, andKey: (self?.appKeyField.text)!, andSite: (self?.getKiiSite())!)
            self?.parentViewController?.view?.makeToast("OK", duration: 1, position: .Bottom,style: style)
            completion(true)
        }

    }
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Manager.SharedManager.childWillLoadedAction(prevButton: ButtonProperties(false,nil), nextButton: DEFAULT_NEXT_BUTTON)
        
    }
    override func viewWillDisappear(animated: Bool) {
        Manager.SharedManager.childWillLoadedAction(prevButton: DEFAULT_PREV_BUTTON, nextButton: DEFAULT_NEXT_BUTTON)
    }

    private func getKiiSite() -> KiiSite {
        switch self.kiiSiteSegment.selectedSegmentIndex {
        case 0:
            return .US
        case 1:
            return .JP
        case 2:
            return .CN
        case 3:
            return .SG
        default:
            return .US
        }
    }
    /// Handle the resign responder button.
    internal func handleResignResponderButton() {

        appIDField?.resignFirstResponder()
        appKeyField?.resignFirstResponder()

    }

    /// Prepares the name TextField.
    private func prepareKiiSite() {

        let siteLabel = MaterialLabel()
        siteLabel.text = "Kii Site :"
        siteLabel.textAlignment = .Center
        view.layout(siteLabel).top(100).horizontally(left: 40, right: 40)

        kiiSiteSegment.selectedSegmentIndex = 1

        view.layout(kiiSiteSegment).top(140).horizontally(left: 40, right: 40)
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
        appKeyField.delegate = self

        // Setting the visibilityFlatButton color.
        appKeyField.visibilityIconButton?.tintColor = MaterialColor.green.base.colorWithAlphaComponent(appKeyField.secureTextEntry ? 0.38 : 0.54)

        // Size the TextField to the maximum width, less 40 pixels on either side
        // with a top margin of 200 pixels.
        view.layout(appKeyField).top(300).horizontally(left: 40, right: 40)
    }

    
}
