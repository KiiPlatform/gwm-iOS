//
//  NodesViewController.swift
//  gwm-iOS
//
//  Created by syahRiza on 6/17/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import Foundation
import Material
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
}

final class NodesViewController: WizardVC {
    private var selectedNodeType = NodeType.Pending
    /// A tableView used to display Bond entries.
    private let tableView: UITableView = UITableView()

    private var selectedNodes : [Node] { return self.items.filter{$0.type == self.selectedNodeType}}

    /// A list of all the Author Bond types.
    private var items: Array<Node> = Array<Node>()

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
        items.append(Node(text: "Ligthing 01", detail: "nodes detail", image: UIImage(named: "cube")?.tintWithColor(MaterialColor.blue.base),type:.Onboarded))
        items.append(Node(text: "Ligthing 02", detail: "nodes detail", image: UIImage(named: "cube")?.tintWithColor(MaterialColor.green.base),type:.Onboarded))
        items.append(Node(text: "Ligthing 03", detail: "nodes detail", image: UIImage(named: "cube")?.tintWithColor(MaterialColor.pink.base),type:.Pending))

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
    }

    @objc private func selectOnboardedNodes(sender: UIButton) {
        print("onboarded")
        self.selectedNodeType = .Onboarded
        self.tableView.reloadData()
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
        let btn1 = RaisedButton(frame: CGRectMake(0,0,130,40))
        btn1.pulseColor = MaterialColor.amber.accent2
        btn1.setTitle(node.type.buttonLabel(), forState: .Normal)
        btn1.setTitleColor(MaterialColor.blue.accent2, forState: .Normal)
        cell.accessoryView = btn1

        
        return cell
    }
    @objc private func nodeAction(sender: Int) {

    }

    
}

/// UITableViewDelegate methods.
extension NodesViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}
