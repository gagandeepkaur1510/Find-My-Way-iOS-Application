//
//  ViewController.swift
//  findMyWay_Gagandeep_C0770112
//
//  Created by Mac on 6/14/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mMap: MKMapView!
    let mLocationManager = CLLocationManager()
    let SPAN = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupLocationManager()
        addDoubleTapGesture()
        
        // Do any additional setup after loading the view.
    }
    
    func setupLocationManager()
    {
        mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        mLocationManager.requestWhenInUseAuthorization()
    }
    
    func addDoubleTapGesture()
    {
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized))
        tap_gesture.numberOfTapsRequired = 2
        mMap.addGestureRecognizer(tap_gesture)
    }
    
    @objc func tapGestureRecognized(gesture: UITapGestureRecognizer)
    {
        let touch_point = gesture.location(in: mMap)
        let coordinates = mMap.convert(touch_point,toCoordinateFrom: mMap)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mMap.addAnnotation(annotation)
    }
    
    @IBAction func findMyWayClicked(_ sender: Any)
    {
        if let location = mLocationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location,span: SPAN)
            mMap.setRegion(region, animated: true)
        }
    }
    
    @IBAction func navigateClicked(_ sender: Any) {
    }
}

