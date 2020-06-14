//
//  ViewController.swift
//  findMyWay_Gagandeep_C0770112
//
//  Created by Mac on 6/14/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mMap: MKMapView!
    let mLocationManager = CLLocationManager()
    let SPAN = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    var mCoordinates: CLLocationCoordinate2D?
    @IBOutlet weak var mSegmentedControl: UISegmentedControl!
    var mTransportType: MKDirectionsTransportType = .automobile
    
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
        self.mCoordinates = coordinates
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mMap.removeAnnotations(mMap.annotations)
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
    
    @IBAction func navigateClicked(_ sender: Any)
    {
        if let destination = mCoordinates, let source = mLocationManager.location?.coordinate
        {
            mMap.removeOverlays(mMap.overlays)
            let request = createDirectionRequest(from: source, to: destination)
            let directions = MKDirections(request: request)
            
            directions.calculate { [unowned self] (response, error) in
                guard let response = response else
                {
                    //TODO: Alert user no response
                    return
                }
                
                for route in response.routes
                {
                    self.mMap.addOverlay(route.polyline)
                    self.mMap.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }
        else
        {
            //TODO: Add Alert for destination or source error
        }
    }
    
    func createDirectionRequest(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> MKDirections.Request
    {
        let starting_location = MKPlacemark(coordinate: from)
        let destination = MKPlacemark(coordinate: to)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: starting_location)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = self.mTransportType
        request.requestsAlternateRoutes = false
        return request
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        if(mTransportType == .automobile)
        {
            renderer.strokeColor = .systemRed
        }
        else if(mTransportType == .walking)
        {
            renderer.strokeColor = .systemBlue
        }
        //        renderer.strokeColor = .systemRed
        return renderer
    }
    
    @IBAction func transportTypeChanged(_ sender: Any) {
        switch mSegmentedControl.selectedSegmentIndex
        {
        case 0:
            self.mTransportType = .automobile
        case 1:
            self.mTransportType = .walking
        default:
            break
        }
    }
    @IBAction func zomIn(_ sender: Any) {
        var region: MKCoordinateRegion = mMap.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mMap.setRegion(region, animated: true)
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        var region: MKCoordinateRegion = mMap.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        mMap.setRegion(region, animated: true)
    }
}
