//
//  FHLDetailReaderViewController.swift
//  Scoops
//
//  Created by javi on 1/3/16.
//  Copyright © 2016 fhl. All rights reserved.
//

import UIKit

class FHLDetailReaderViewController: UIViewController {

    var selectedObject: [NSObject: AnyObject]?
    var indexSelected: Int?
    
    var myBlobName : String = "noImage.png"
    var myImage: NSData?
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var texto_noticia: UITextView!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var valoracion: UITextField!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titulo.text = FHLAzureCommunication.model![indexSelected!]["titulo"] as? String
        self.texto_noticia.text = FHLAzureCommunication.model![indexSelected!]["texto_noticia"] as? String
        self.selectedObject = FHLAzureCommunication.model![indexSelected!] as? [NSObject : AnyObject]
        
        FHLAzureCommunication.downloadBlobFromModelWithIndex(indexSelected!, forImage: self.foto)

        //comprobar autenticación
        FHLAzureCommunication.checkAutenticationInController(self)
    }
    
    // MARK: - IBActions
    @IBAction func addRating(sender: AnyObject) {
        
        self.selectedObject!["valorado"] = true
        self.selectedObject!["valoracion_individual"] = valoracion.text
        
        FHLAzureCommunication.tablaNoticias?.update(selectedObject, completion: { (updated, error: NSError?) -> Void in
            if error != nil {
                print("Error al valorar la noticia")
                self.showMessage("Error al valorar la noticia", withTitle: "Error")
            } else {
                self.showMessage("Noticia valorada", withTitle: "Información")
            }
        })
    }
}