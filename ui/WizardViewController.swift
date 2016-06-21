//
//  WizardViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/21/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material

class MainWizardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Manager.SharedManager.childWillLoadedAction = { [weak self] (prevButtonProperties,nextButtonProperties) in
            self?.nextButton.enabled = nextButtonProperties.enabled
            self?.nextButton.title = nextButtonProperties.title?.capitalizedString

            self?.prevButton.enabled = prevButtonProperties.enabled
            self?.prevButton.title = prevButtonProperties.title?.capitalizedString

        }
        // Do any additional setup after loading the view, typically from a nib.


    }

    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var prevButton: UIBarButtonItem!

    @IBOutlet weak var container: UIView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToPrev(sender: AnyObject){
        Manager.SharedManager.prevVC()
    }

    @IBAction func goToNext(sender: AnyObject){
        Manager.SharedManager.nextVC()
        
    }
}


class WizardVC: UIViewController, TextFieldDelegate {

    override func viewWillAppear(animated: Bool) {
        Manager.SharedManager.currentVC = self

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
extension UIViewController {
    func canPerformSegueWithIdentifier(identifier: NSString) -> Bool {
        guard let templates:NSArray = self.valueForKey("storyboardSegueTemplates") as? NSArray else {
            return false
        }
        let predicate:NSPredicate = NSPredicate(format: "identifier=%@", identifier)

        let filteredtemplates = templates.filteredArrayUsingPredicate(predicate)
        return (filteredtemplates.count>0)
    }
}