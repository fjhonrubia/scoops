//
//  FHLReadersTableViewController.swift
//  Scoops
//
//  Created by javi on 1/3/16.
//  Copyright © 2016 fhl. All rights reserved.
//

import UIKit

class FHLReadersTableViewController: UITableViewController {

    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        FHLAzureCommunication.populateModelWithPredicate(NSPredicate(format: "disponible = true AND estado_publicado = true", argumentArray: nil), forController: self)
        
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let rows = FHLAzureCommunication.model?.count {
            return rows
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("newsReaderCell")
        if (cell == nil) {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "newsReaderCell")
        }

        cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "newsReaderCell")

        cell!.textLabel?.text = FHLAzureCommunication.model![indexPath.row]["titulo"] as? String
        cell!.detailTextLabel?.text = FHLAzureCommunication.model![indexPath.row]["autor"] as? String
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = FHLDetailReaderViewController()
        detailVC.indexSelected = indexPath.row
        
        //Se hace un push en el navigation controller
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
