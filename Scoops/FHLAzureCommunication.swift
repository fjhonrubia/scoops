//
//  FHLAzureCommunication.swift
//  Scoops
//
//  Created by javi on 29/2/16.
//  Copyright © 2016 fhl. All rights reserved.
//

import UIKit

class FHLAzureCommunication: NSObject {
    
    static let kEndpointMobileService = "https://fjhonru.azure-mobile.net/"
    static let kAppKeyMobileService = "NhqsiNLzNWjHayOlqXhOlwgsuTfanS73"
    static let kEndpointAzureStorage = "https://videoblogapp.blob.core.windows.net"
    
    static var client =  MSClient(applicationURL: NSURL(string: kEndpointMobileService), applicationKey: kAppKeyMobileService)
    
    static var model: [AnyObject]?
    
    static var tablaNoticias: MSTable?
    
    class func saveAuthInfo (currentUser : MSUser?){
        
        NSUserDefaults.standardUserDefaults().setObject(currentUser?.userId, forKey: "userId")
        NSUserDefaults.standardUserDefaults().setObject(currentUser?.mobileServiceAuthenticationToken, forKey: "tokenId")
        
    }
    
    class func loadUserAuthInfo() -> (usr : String, tok : String)? {
        
        let user = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String
        let token = NSUserDefaults.standardUserDefaults().objectForKey("tokenId") as? String
        
        return (user!, token!)
    }
    
    
    class func isUserLogged() -> Bool {
        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String {
            return true
        }
        return false
        
    }
    
    class func populateModelWithPredicate(predicate: NSPredicate?, forController: UITableViewController) {
        
        let newsTable = client?.tableWithName("noticias")
        
        let query = MSQuery(table: newsTable)
        
        if let predicateQuery = predicate {
            query.predicate = predicateQuery
        }
        
        query.orderByAscending("titulo")
        query.readWithCompletion { (result:MSQueryResult?, error:NSError?) -> Void in
            if error == nil {
                model = result?.items
                forController.tableView.reloadData()
            } else {
                print("Error al recuperar noticias: \(error)")
            }
        }
    }
    
    class func uploadToStorage(data : NSData, blobName : String){
        
        client?.invokeAPI("urlsastoblobandcontainer",
            body: nil,
            HTTPMethod: "GET",
            parameters: ["blobName" : blobName, "ContainerName" : "fotosnoticias"],
            headers: nil,
            completion: { (result : AnyObject?, response : NSHTTPURLResponse?, error: NSError?) -> Void in
                
                if error == nil{
                    
                    // 2: Tenemos solo la ruta del container/blob + la SASURL
                    let sasURL = result!["sasUrl"] as? String
                    
                    // 3: url del endpoint de Storage
                    var endPoint = "https://fjhonru.blob.core.windows.net"
                    
                    endPoint += sasURL!
                    
                    // 4: Hemos apuntado al container de AZure Storage
                    let container = AZSCloudBlobContainer(url: NSURL(string: endPoint)!)
                    
                    // 5: Creamo nuestro blob local
                    
                    let blobLocal = container.blockBlobReferenceFromName(blobName)
                    
                    // 6: Vamos a hacer el upload de nuestro blob local + NSData
                    
                    blobLocal.uploadFromData(data,
                        completionHandler: { (error: NSError?) -> Void in
                            
                            if error != nil {
                                print("Tenemos un error -> \(error)")
                            }
                            
                    })
                    
                }
        })
        
    }
    
    class func downloadBlobFromModelWithIndex(index: Int, forImage: UIImageView) {
        
        let blobName = (model![index]["foto"] as? String)!
        
        client?.invokeAPI("urlsastoblobandcontainer",
            body: nil,
            HTTPMethod: "GET",
            parameters: ["blobName" : blobName, "ContainerName" : (model![index]["containername"] as? String)!],
            headers: nil,
            completion: { (result : AnyObject?, response : NSHTTPURLResponse?, error: NSError?) -> Void in
                
                if error == nil{
                    
                    // 2: Tenemos solo la ruta del container/blob + la SASURL
                    let sasURL = result!["sasUrl"] as? String
                    
                    // 3: url del endpoint de Storage
                    var endPoint = "https://fjhonru.blob.core.windows.net"
                    
                    endPoint += sasURL!
                    
                    // 4: Hemos apuntado al container de AZure Storage
                    let container = AZSCloudBlobContainer(url: NSURL(string: endPoint)!)
                    
                    // 5: Creamo nuestro blob local
                    
                    let blobLocal = container.blockBlobReferenceFromName(blobName)
                    
                    // 6: Vamos a hacer el download del blob y la actualización de la interfaz
                    
                    blobLocal.downloadToDataWithCompletionHandler({ (error: NSError?, data: NSData?) -> Void in
                        if error == nil {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                forImage.image = UIImage(data: data!)!
                            })
                            
                        } else {
                            print("Error al recuperar imagen")
                        }
                    })
                    
                }
                
        })
    }
    
    class func checkAutenticationInController(controller: UIViewController) {
        
        if isUserLogged() {
            
            // Cargamos los datos del usuario que ya hizo login
            if let usrlogin = loadUserAuthInfo() {
                client!.currentUser = MSUser(userId: usrlogin.usr)
                client!.currentUser.mobileServiceAuthenticationToken = usrlogin.tok
                
                tablaNoticias = client?.tableWithName("noticias")
                
            }
        } else {
            
            //No se está logado, hay que logarse
            client!.loginWithProvider("facebook", controller: controller, animated: true, completion: { (user: MSUser?, error: NSError?) -> Void in
                
                if (error != nil){
                    print("Tenemos Problemas")
                } else{
                    
                    // Persistimos los credenciales del usuario
                    saveAuthInfo(user)
                    
                }
            })
        }
    }}
