//
//  SearchMapViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 15/1/2022.
//

import UIKit
import MapKit
import CoreLocation

class SearchMapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set location xy
        let coordation = CLLocationCoordinate2D(latitude: 35, longitude: 20)
        
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
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
