//
//  SearchMapViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 15/1/2022.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class SearchMapViewController: UIViewController, CLLocationManagerDelegate {
    
    init(){}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let database = Database.database().reference()

    var gymLocation: Double
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_sender:)))
        self.view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    // call search the location function
    @objc func backgroundTapped(_sender: UITapGestureRecognizer){
        self.searchTF.endEditing(true)
    }
    
    //set up the location manager and request permission
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    //implement the location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            self.searchTF.text = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
            render(location, tilte: "Current")
        }
    }
    
    //search the location by user input
    @IBAction func finishEditing(_ sender: Any) {
       
        if let textField = sender as? UITextField {
            let address = gymLocation
            
            if let address = address {
                geoCoder.geocodeAddressString(address) { (placemark, error) in self.findLocation(placemarks: placemark, error: error, address: address)
                }
            }
        }
    }
    
    //check the lcation is or is not correct
    func findLocation(placemarks: [CLPlacemark]?, error: Error?, address: String) {
        var location: CLLocation?
        // if the location not correct display "No result" on textfield
        if let error = error {
            self.searchTF.text = "No result"
        }
        else {
            if let placemarks = placemarks, !placemarks.isEmpty {
                location = placemarks.first?.location
            }
            // if location is correct, it display the location lat and long on annotation
            if let location = location {
                render(location, tilte: address)
                
                self.searchTF.text = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
            }
            else {
                self.searchTF.text = "No result"
            }
        }
    }
    
    // traking the user location and set up the annotation
    func render(_ location: CLLocation, tilte: String){
        
        let coordation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        
        let region = MKCoordinateRegion(center: coordation, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordation
        pin.title = tilte
        pin.subtitle = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        mapView.addAnnotation(pin)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
