//
//  FHLNewNewsViewController.swift
//  Scoops
//
//  Created by javi on 26/2/16.
//  Copyright © 2016 fhl. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation

class FHLNewNewsViewController: UIViewController {
    
    var insertedObject: [NSObject: AnyObject]?
    var indexSelected: Int?
    
    var myBlobName : String = "noImage.png"
    var myImage: NSData?
    
    var locationManager: CLLocationManager?
    var latitud: Double = 0.0
    var longitud: Double = 0.0

    @IBOutlet weak var autor: UITextField!
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var texto: UITextView!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var longitudView: UILabel!
    @IBOutlet weak var latitudView: UILabel!
    @IBOutlet weak var aniadir: UIButton!
    @IBOutlet weak var disponible: UIButton!
    
    @IBAction func addAvailable(sender: AnyObject) {
        
        self.insertedObject!["disponible"] = true
        
        FHLAzureCommunication.tablaNoticias?.update(insertedObject, completion: { (updated, error: NSError?) -> Void in
            if error != nil {
                print("Error al hacer disponible la noticia")
                self.showMessage("No se ha podido poner la noticia disponble", withTitle: "Error")
            }
            self.showMessage("Noticia Disponible", withTitle: "Información")
            self.showMessage("Noticia disponible", withTitle: "Información")
        })
        
    }
    @IBAction func addNew(sender: AnyObject) {
        
        if insertedObject == nil {
            //se añade un nuevo elemento
            
            FHLAzureCommunication.tablaNoticias?.insert(["titulo" : self.titulo.text!, "texto_noticia": self.texto.text!, "autor": self.autor.text!, "latitud": latitud, "longitud": longitud, "estado_publicado": false, "disponible": false, "foto" : myBlobName, "containername" : "fotosnoticias"], completion: { (inserted, error: NSError?) -> Void in
                
                if error != nil{
                    print("Tenemos un error -> : \(error)")
                    self.showMessage("No se ha podido crear la noticia", withTitle: "Error")
                } else {
                    
                    // 2: Persistir el blob en el Storage siempre y cuando haya imagen
                    if self.myBlobName != "noImage.png" {
                        FHLAzureCommunication.uploadToStorage(self.myImage!, blobName: self.myBlobName)
                    }
                    self.insertedObject = inserted
                    self.disponible.enabled = true
                    self.showMessage("Noticia Creada", withTitle: "Información")

                }
            })
            
        } else {
            //se modifica el elemento
            
            self.insertedObject!["autor"] = self.autor.text
            self.insertedObject!["titulo"] = self.titulo.text
            self.insertedObject!["texto_noticia"] = self.texto.text
            
            FHLAzureCommunication.tablaNoticias?.update(insertedObject, completion: { (updated, error: NSError?) -> Void in
                if error != nil {
                    print("Error al modificar la noticia")
                    self.showMessage("No se ha podido modificar la noticia", withTitle: "Error")
                } else {
                    self.disponible.enabled = true
                    self.showMessage("Noticia modificada", withTitle: "Información")
                }
            })
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //se configuran los campos que se puedan obtener
        //self.autor.text = FHLAzureCommunication.client?.currentUser.userId
        self.latitudView.text = "Latitud: N/A"
        self.longitudView.text = "Longitud: N/A"
        self.disponible.enabled = false

        //se mira a ver si hay datos para rellenar la pantalla
        if indexSelected != nil {
            self.titulo.text = FHLAzureCommunication.model![indexSelected!]["titulo"] as? String
            self.texto.text = FHLAzureCommunication.model![indexSelected!]["texto_noticia"] as? String
            self.autor.text = FHLAzureCommunication.model![indexSelected!]["autor"] as? String
            self.insertedObject = FHLAzureCommunication.model![indexSelected!] as? [NSObject : AnyObject]
            
            self.aniadir.setTitle("Modificar", forState: .Normal)
            
            FHLAzureCommunication.downloadBlobFromModelWithIndex(indexSelected!, forImage: self.foto)
            
        } else {
            //se añade un gesture regconizer a la foto
            self.foto.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: "captureImage:")
            self.foto.addGestureRecognizer(tap)
        }
        
        //comprobar autenticación
        FHLAzureCommunication.checkAutenticationInController(self)
        
        //obtiene la localizacion
        obtainLocation()
    }

}

// MARK: - Captura Imagen
extension FHLNewNewsViewController {
    
    func captureImage(sender: AnyObject) {
        startCaptureImageFromViewController(self, withDelegate: self)
    }
    
    func startCaptureImageFromViewController(viewcontroller: UIViewController, withDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool{
        
        let cameraController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            cameraController.sourceType = .Camera
        } else {
            cameraController.sourceType = .PhotoLibrary
        }

        cameraController.mediaTypes = [kUTTypeImage as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        presentViewController(cameraController, animated: true, completion: nil)
        
        return true

    }
}

// MARK: - UIImagePickerControllerDelegate

extension FHLNewNewsViewController: UINavigationControllerDelegate{
    
}

// MARK: - UIImagePickerControllerDelegate

extension FHLNewNewsViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        dismissViewControllerAnimated(true, completion :nil)
        
        if (mediaType == kUTTypeImage as String){
            
            let imageTaken = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            //se muestra la imagen que se ha capturado
            myImage = UIImageJPEGRepresentation(imageTaken, 0.9)
            self.foto.image = imageTaken
            myBlobName = "image-\(NSUUID().UUIDString).jpeg"
        }
        
    }
}

// MARK: - CoreLocation
extension FHLNewNewsViewController: CLLocationManagerDelegate {
    
    func obtainLocation() {
        
        let seconds: UInt64 = 5
        
        let status = CLLocationManager.authorizationStatus()
        
        if (status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.NotDetermined || status == CLAuthorizationStatus.AuthorizedWhenInUse) && (CLLocationManager.locationServicesEnabled()) {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.distanceFilter = kCLDistanceFilterNone
            
            self.locationManager?.requestWhenInUseAuthorization()
            self.locationManager?.startMonitoringSignificantLocationChanges()
            self.locationManager?.startUpdatingLocation()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                self.zapLocationManager()
            })
            
        }
    }
    
    func zapLocationManager() {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        self.locationManager = nil
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Fallo en el LocationManager")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // paramos el location manager, que consume mucha bateria
        self.zapLocationManager()
        
        //Se obtienen la última location que se ha generado y se almacena su latitud y su longitud
        self.latitud = (locations.last?.coordinate.latitude)!
        self.longitud = (locations.last?.coordinate.longitude)!
        
        //Se actualiza el UI
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.latitudView.text = "Latitud: " + self.latitud.description
            self.longitudView.text = "Longitud: " + self.longitud.description
        }
    }
}
