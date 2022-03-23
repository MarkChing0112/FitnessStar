//
//  SearchMapViewController.swift
//  FypTest_APP
//
//  Created by MARK ching on 15/1/2022.
//

import UIKit
import MapKit
import CoreLocation

class SearchMapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var x = 22.421609
    var y = 114.169242
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set location xy
        let coordation = CLLocationCoordinate2D(latitude: x, longitude: y)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        
        let region = MKCoordinateRegion(center: coordation, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordation
        pin.title = "gymroom"
        mapView.addAnnotation(pin)
        // Do any additional setup after loading the view.
    }
    // call search the location function
 

}
