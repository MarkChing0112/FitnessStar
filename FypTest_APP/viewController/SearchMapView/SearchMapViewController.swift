//
//  SearchMapViewController.swift
//  FypTest_APP


import UIKit
import MapKit
import CoreLocation

class SearchMapViewController: UIViewController, CLLocationManagerDelegate {
    
    //mpa
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    // firebase
    var x: String!
    var y: String!
    var gymroom: String!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // call search the location function
        // set location xy
        let coordation = CLLocationCoordinate2D(latitude: Double(x) ?? 0.0, longitude: Double(y) ?? 0.0)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        
        let region = MKCoordinateRegion(center: coordation, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordation
        pin.title = gymroom
        mapView.addAnnotation(pin)
    }

}
