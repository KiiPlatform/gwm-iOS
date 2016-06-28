//
//  NodesViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/17/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material
import ThingIFSDK
import Toast_Swift

private let nodeActionlabel = ["On Board","Send"]


enum NodeType : Int{
    case Pending, Onboarded

    func buttonLabel() -> String {
        return nodeActionlabel[self.rawValue]
    }
}

private struct Node {
    var text: String
    var detail: String
    var image: UIImage?
    var type : NodeType
    var thingObj : AnyObject


    init(pendingNode: PendingEndNode){
        text = pendingNode.vendorThingID!
        detail = "stat  : Pending"
        image = UIImage(named: "cube")?.tintWithColor(MaterialColor.amber.accent1)
        type = .Pending
        thingObj = pendingNode

    }

    init(endNode: EndNode){
        text = endNode.vendorThingID
        detail = "vendor id  : \(endNode.thingID)"
        image = UIImage(named: "cube")
        type = .Onboarded
        thingObj = endNode
    }
}



final class NodesViewController: WizardVC {
    private var savedGateway : Gateway?

    private var selectedNodeType = NodeType.Pending
    /// A tableView used to display Bond entries.
    private let tableView: UITableView = UITableView()

    private var selectedNodes : [Node] {
        if self.selectedNodeType == .Pending { return pendingNodes} else { return endNodes }
    }

    /// A list of all the Author Bond types.
    private var items: Array<Node> = Array<Node>()
    private var pendingNodes: Array<Node> = Array<Node>()
    private var endNodes: Array<Node> = Array<Node>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nodes"
        prepareView()
        prepareItems()
        prepareTableView()
        prepareCardView()
    }

    /// Prepares view.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }

    /// Prepares the items Array.
    private func prepareItems() {


    }

    /// Prepares the tableView.
    private func prepareTableView() {
        tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    /// Prepares the CardView.
    func prepareCardView() {

        let cardView: CardView = CardView()
        cardView.backgroundColor = MaterialColor.grey.lighten5
        cardView.cornerRadiusPreset = .Radius1
        cardView.divider = false
        cardView.contentInsetPreset = .None
        cardView.leftButtonsInsetPreset = .Square2
        cardView.rightButtonsInsetPreset = .Square2
        cardView.contentViewInsetPreset = .None

        // Use Layout to easily align the tableView.

        cardView.contentView = tableView
        let tabBar: TabBar = TabBar(frame: CGRectMake(0, 0, cardView.bounds.width, 60))
        tabBar.backgroundColor = MaterialColor.blue.base
        let pendingTab: FlatButton = FlatButton()
        pendingTab.pulseColor = MaterialColor.white
        pendingTab.setTitle("Pending", forState: .Normal)
        pendingTab.setTitleColor(MaterialColor.white, forState: .Normal)
        pendingTab.addTarget(self, action: #selector(NodesViewController.selectPendingNodes(_:)), forControlEvents: .TouchUpInside)

        let onboardedTab: FlatButton = FlatButton()
        onboardedTab.pulseColor = MaterialColor.white
        onboardedTab.setTitle("Onboarded", forState: .Normal)
        onboardedTab.setTitleColor(MaterialColor.white, forState: .Normal)
        onboardedTab.addTarget(self, action: #selector(NodesViewController.selectOnboardedNodes(_:)), forControlEvents: .TouchUpInside)
        tabBar.buttons = [pendingTab, onboardedTab]

        cardView.addSubview(tabBar)

        view.layout(cardView).edges(left: 10, right: 10, top: 80, bottom: 10)
    }

    @objc private func selectPendingNodes(sender: UIButton) {
        print("pending")
        self.selectedNodeType = .Pending
        self.tableView.reloadData()
        guard let savedGatewayAPI = try? GatewayAPI.loadWithStoredInstance() else {
            self.performSegueWithIdentifier("showWizard", sender: nil)
            return
        }
        savedGatewayAPI?.listPendingEndNodes({ (nodes, error) in
            if let pendingNodes = nodes as [PendingEndNode]? {
                self.pendingNodes = pendingNodes.map({ (obj) -> Node in
                    Node(pendingNode: obj)
                })
                self.tableView.reloadData()

            }
        })
    }

    @objc private func selectOnboardedNodes(sender: UIButton) {
        print("onboarded")
        self.selectedNodeType = .Onboarded
        self.tableView.reloadData()
        guard let savedGatewayAPI = try? GatewayAPI.loadWithStoredInstance() else {
            self.performSegueWithIdentifier("showWizard", sender: nil)
            return
        }
        savedGatewayAPI?.listOnboardedEndNodes({ (nodes, error) in
            if let endNodes = nodes as [EndNode]? {
                self.endNodes = endNodes.map({ (obj) -> Node in
                    Node(endNode: obj)
                })
                self.tableView.reloadData()

            }
        })

    }
}

/// TableViewDataSource methods.
extension NodesViewController: UITableViewDataSource {
    /// Determines the number of rows in the tableView.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedNodes.count
    }

    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "Cell")

        let node: Node = self.selectedNodes[indexPath.row]

        cell.selectionStyle = .None
        cell.textLabel!.text = node.text
        cell.textLabel!.font = RobotoFont.regular
        cell.detailTextLabel!.text = node.detail
        cell.detailTextLabel!.font = RobotoFont.regular
        cell.detailTextLabel!.textColor = MaterialColor.grey.darken1
        cell.imageView!.image = node.image?.resize(toWidth: 40)
        cell.imageView!.layer.cornerRadius = 20
        let actionButton = RaisedButton(frame: CGRectMake(0,0,130,40))
        actionButton.pulseColor = MaterialColor.amber.accent2
        actionButton.setTitle(node.type.buttonLabel(), forState: .Normal)
        actionButton.setTitleColor(MaterialColor.blue.accent2, forState: .Normal)
        actionButton.addTarget(self, action: #selector(NodesViewController.nodeAction(_:)), forControlEvents: .TouchUpInside)
        actionButton.tag = indexPath.row
        cell.accessoryView = actionButton

        return cell
    }
    @objc private func nodeAction(sender: UIButton) {
        let node: Node = self.selectedNodes[sender.tag]
        print(node.text)
        guard let api = try? ThingIFAPI.loadWithStoredInstance() else {

            return
        }
        var style = ToastStyle()
        style.backgroundColor = MaterialColor.blue.accent2.colorWithAlphaComponent(0.5)

        let alertController : UIAlertController
        let nodeAction : UIAlertAction
        switch node.type {
        case .Onboarded:
            alertController = UIAlertController(title: "Post Command", message: "Post Command to thing", preferredStyle: .Alert)
            nodeAction = UIAlertAction(title: "Send", style: .Default) { (_) in
                let actions : [Dictionary<String, AnyObject>] = [["TurnPower": ["power": true]]]

                let form = CommandForm(schemaName: "Smart-Light-Demo", schemaVersion: 1, actions: actions)
                let endNode = node.thingObj as! EndNode
                let tApi = api?.copyWithTarget(endNode)
                tApi?.postNewCommand(form, completionHandler: { (cmd, error) in
                    if cmd != nil {
                        style.backgroundColor = MaterialColor.blue.darken2.colorWithAlphaComponent(0.7)
                        self.parentViewController?.view?.makeToast("Command sent", duration: 1, position: .Center,style: style)
                    } else {
                        style.backgroundColor = MaterialColor.red.accent3.colorWithAlphaComponent(0.7)
                        self.parentViewController?.view?.makeToast("Error :\(error!)", duration: 3, position: .Center,style: style)
                    }
                })

            }

            break
        case .Pending:
            let pendingNode = node.thingObj as! PendingEndNode


            alertController = UIAlertController(title: "Onboard", message: "Vendor Thing ID : \(node.text)", preferredStyle: .Alert)
            nodeAction = UIAlertAction(title: "Onboard", style: .Default) { (_) in

                self.tableView.makeToastActivity(.Center)

                let passwordTextField = alertController.textFields![0] as UITextField
                let password = passwordTextField.text!

                let tApi = api?.copyWithTarget(self.savedGateway!)
                tApi?.onboardEndnodeWithGateway(pendingNode, endnodePassword: password, completionHandler: { (node, error) in
                    self.tableView.hideToastActivity()
                    let api = try? GatewayAPI.loadWithStoredInstance()
                    if node != nil {
                        api!?.notifyOnboardingCompletion(node!, completionHandler: { (_) in
                            style.backgroundColor = MaterialColor.blue.darken2.colorWithAlphaComponent(0.7)
                            self.parentViewController?.view?.makeToast("Onboarded", duration: 1, position: .Center,style: style)
                            self.pendingNodes.removeAtIndex(sender.tag)
                            let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
                            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
                            self.tableView.reloadData()
                        })
                    } else {
                        style.backgroundColor = MaterialColor.red.accent3.colorWithAlphaComponent(0.7)
                        self.parentViewController?.view?.makeToast("Error :\(error!)", duration: 3, position: .Center,style: style)
                    }
                })
            }
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Password"
                textField.text = "password"
                textField.secureTextEntry = true
            }
            break
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alertController.addAction(nodeAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }

}

extension NodesViewController {
    override func viewDidAppear(animated: Bool) {
        self.parentViewController?.view?.makeToastActivity(.Center)

        guard let savedGatewayAPI = try? GatewayAPI.loadWithStoredInstance() else {
            self.performSegueWithIdentifier("showWizard", sender: nil)
            return
        }
        savedGatewayAPI?.onboardGateway({ (gateway, error) in
            self.savedGateway = gateway

            savedGatewayAPI?.listOnboardedEndNodes({ (nodes, error) in
                if let endNodes = nodes as [EndNode]? {
                    self.endNodes = endNodes.map({ (obj) -> Node in
                        Node(endNode: obj)
                    })
                    self.tableView.reloadData()

                }
            })
            savedGatewayAPI?.listPendingEndNodes({ (nodes, error) in
                if let pendingNodes = nodes as [PendingEndNode]? {
                    self.pendingNodes = pendingNodes.map({ (obj) -> Node in
                        Node(pendingNode: obj)
                    })
                    self.tableView.reloadData()
                    self.parentViewController?.view.hideToastActivity()
                }
            })
        })
        
    }
    
}
/// UITableViewDelegate methods.
extension NodesViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}
