//
//  FHLInitViewController.swift
//  Scoops
//
//  Created by Fco. Javier Honrubia Lopez on 27/2/16.
//  Copyright © 2016 fhl. All rights reserved.
//

import UIKit

class FHLInitViewController: UIViewController {
    

    @IBAction func loginWriter(sender: AnyObject) {
        
        // primero comprobar si estamos logados
        if FHLAzureCommunication.isUserLogged() {
              
            // Cargamos los datos del usuario que ya hizo login
            if let usrlogin = FHLAzureCommunication.loadUserAuthInfo() {
                FHLAzureCommunication.client.currentUser = MSUser(userId: usrlogin.usr)
                FHLAzureCommunication.client.currentUser.mobileServiceAuthenticationToken = usrlogin.tok
                
                //Se crea y configura el View Controller
                let writersVC = FHLWritersTableViewController()
                
                //Se hace un push en el navigation controller
                self.navigationController?.pushViewController(writersVC, animated: true)
                
            }
            
        } else{
            
            FHLAzureCommunication.client.loginWithProvider("facebook", controller: self, animated: true, completion: { (user: MSUser?, error: NSError?) -> Void in
                
                if (error != nil){
                    print("Tenemos Problemas")
                } else{
                    
                    FHLAzureCommunication.saveAuthInfo(user)
                    
                    //Se crea y configura el View Controller
                    let writersVC = FHLWritersTableViewController()
                    
                    //Se hace un push en el navigation controller
                    self.navigationController?.pushViewController(writersVC, animated: true)
                    
                }
            })
        }
        
        
    }
    
    @IBAction func loginReader(sender: AnyObject) {
        
        // primero comprobar si estamos logados
        if FHLAzureCommunication.isUserLogged() {
            
            // Cargamos los datos del usuario que ya hizo login
            if let usrlogin = FHLAzureCommunication.loadUserAuthInfo() {
                FHLAzureCommunication.client.currentUser = MSUser(userId: usrlogin.usr)
                FHLAzureCommunication.client.currentUser.mobileServiceAuthenticationToken = usrlogin.tok
                
                //Se crea y configura el View Controller
                let readersVC = FHLReadersTableViewController()
                
                //Se hace un push en el navigation controller
                self.navigationController?.pushViewController(readersVC, animated: true)
                
            }
            
        } else{
            
            FHLAzureCommunication.client.loginWithProvider("facebook", controller: self, animated: true, completion: { (user: MSUser?, error: NSError?) -> Void in
                
                if (error != nil){
                    print("Tenemos Problemas")
                } else{
                    
                    FHLAzureCommunication.saveAuthInfo(user)
                    
                    //Se crea y configura el View Controller
                    let readersVC = FHLReadersTableViewController()
                    
                    //Se hace un push en el navigation controller
                    self.navigationController?.pushViewController(readersVC, animated: true)
                    
                }
            })
        }
    }

}
