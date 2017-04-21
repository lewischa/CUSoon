//
//  StatusViewController.swift
//  CUSoon
//
//  Created by student on 4/17/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StatusViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let colors = Colors()
    //var currLocation:CLLocation = CLLocation()
    var lManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Set Location manager
        lManager.delegate = self
        lManager.desiredAccuracy = kCLLocationAccuracyBest
        lManager.distanceFilter = 5
        lManager.requestWhenInUseAuthorization()
        lManager.startUpdatingLocation()
        
        
        //Initialize map
        let span = MKCoordinateSpanMake(0.32, 0.32)
        let region = MKCoordinateRegionMake((lManager.location?.coordinate)!, span)
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
//        let currentLocation = CLLocation(latitude: 37.780085, longitude: -122.433824)
       // drawRoute(currentLocation: currentLocation)
        
        
        lManager.stopUpdatingLocation()
        configureColors()
        // Do any additional setup after loading the view.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        drawRoute(currentLocation: userLocation)
        
    }
    
    func drawRoute(currentLocation: CLLocation){
        let sourceLocation = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: 38.338041, longitude: -122.675358)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
//            let rect = route.polyline.boundingMapRect
            
            let testRectSize: MKMapSize = MKMapSize(width: route.polyline.boundingMapRect.size.width * 1.06, height: route.polyline.boundingMapRect.size.height * 1.06)
            let testRect = MKMapRect(origin: route.polyline.boundingMapRect.origin, size: testRectSize)
            
            self.mapView.setRegion(MKCoordinateRegionForMapRect(testRect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = colors.titleOrage
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureColors() {
        let textColor = UIColor(red: 255/255, green: 171/255, blue: 74/255, alpha: 1)
        let backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
        navigationController?.navigationBar.barTintColor = backgroundColor
        view.backgroundColor = backgroundColor
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
