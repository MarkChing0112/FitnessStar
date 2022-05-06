//
//  SearchMapViewController.swift
//  FypTest_APP


import UIKit
import MapKit
import CoreLocation
import FirebaseStorage

class SearchMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var GymRoomImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telePhoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var gymRoomNameLabel: UILabel!
    
    
    //map
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    //var activity = [SearchGymRoomModel]()
    
    // firebase
    var x: String!
    var y: String!
    var GymRoom_name: String!
    var TelPhone: String!
    var Address: String!
    var Website: String!
    var GymRoomURL: String!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // print GymRoom Detail
        gymRoomNameLabel.text = GymRoom_name
        addressLabel.text = Address
        telePhoneLabel.text = TelPhone
        websiteLabel.text = Website
        
        
        // call search the location function
        // set location xy
        let coordation = CLLocationCoordinate2D(latitude: Double(x) ?? 0.0, longitude: Double(y) ?? 0.0)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        
        let region = MKCoordinateRegion(center: coordation, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordation
        pin.title = GymRoom_name
        mapView.addAnnotation(pin)
        
        getGymRoomImage()
    }
    
    // get gymRoom Image from firebase
    func getGymRoomImage() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(GymRoomURL)
        
        
        fileRef.getData(maxSize: 10*3024*4032) { Data, Error in
            if Error == nil && Data != nil {
                self.GymRoomImageView.image = UIImage(data: Data!)
            }
        }
    }

}
