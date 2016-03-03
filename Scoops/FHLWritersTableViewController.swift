//
//  FHLWritersTableViewController.swift
//  Scoops
//
//  Created by javi on 26/2/16.
//  Copyright © 2016 fhl. All rights reserved.
//

import UIKit

class FHLWritersTableViewController: UITableViewController {
    
    var filterNewsSC = UISegmentedControl()
    
    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Botón para añadir noticias
        self.title = "News"
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNews")
        self.navigationItem.rightBarButtonItem = addButton
        
        //Se registra la celda
        self.tableView.registerNib(UINib(nibName: "FHLNewsViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        FHLAzureCommunication.populateModelWithPredicate(nil, forController: self)
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            //se crea un segmented control para filtrar las noticias
            filterNewsSC = UISegmentedControl(items: ["All", "Available", "Not avilable"])
            filterNewsSC.frame = CGRect(x: 10, y: 0, width: self.view.bounds.size.width-10, height: self.view.bounds.size.height)
            
            //se le asocia una acción ante el evento de cambio
            filterNewsSC.addTarget(self, action: "refreshTableView", forControlEvents: UIControlEvents.ValueChanged)
            
            return filterNewsSC
            
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as? FHLNewsViewCell

        cell!.titulo.text = FHLAzureCommunication.model![indexPath.row]["titulo"] as? String
        
        if let rating = FHLAzureCommunication.model![indexPath.row]["valoracion"] as? Int{
            cell!.valoracion.text = String(rating)
        } else {
            cell!.valoracion.text = "0"
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //se abre FHLNewNewsVierController pasándole el objeto que se ha seleccionado y desactivando el botón de añadir
        let nnVC = FHLNewNewsViewController()
        nnVC.indexSelected = indexPath.row
        
        //Se hace un push en el navigation controller
        self.navigationController?.pushViewController(nnVC, animated: true)
        
    }

}

// MARK: - Utils

extension FHLWritersTableViewController {
    
    func addNews() {
        
        //Se crea y configura el View Controller
        let nnVC = FHLNewNewsViewController()
        
        //Se hace un push en el navigation controller
        self.navigationController?.pushViewController(nnVC, animated: true)
        
    }
}

// MARK: - Segmented Control Events

extension FHLWritersTableViewController {
    
    func refreshTableView() {
        
        switch filterNewsSC.selectedSegmentIndex{
        case 0:
            print("All")
            //cargamos todas las noticias
            FHLAzureCommunication.populateModelWithPredicate(nil, forController: self)
        case 1:
            print("Available")
            //Cargamos en el modelo solamente aquellas noticias con estado_publicado = true
            FHLAzureCommunication.populateModelWithPredicate(NSPredicate(format: "disponible = true", argumentArray: nil), forController: self)
        case 2:
            print("Not available")
            //Cargamos en el modelo solamente aquellas noticias con estado_publicado = false
            FHLAzureCommunication.populateModelWithPredicate(NSPredicate(format: "disponible = false", argumentArray: nil), forController: self)
        default:
            print("Not an option")
        }
        
    }
}
