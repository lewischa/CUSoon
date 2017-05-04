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
    @IBOutlet weak var timeToDest: UILabel!
    @IBOutlet weak var distToDest: UILabel!
    @IBOutlet weak var serviceTitle: UILabel!
    
    @IBOutlet weak var cancel: UIButton!
    @IBAction func cancelButton(_ sender: Any) {
        lManager.stopUpdatingLocation()
        navigationItem.setHidesBackButton(false, animated: true)
        cancel.isEnabled = false
        UIView.animate(withDuration: 0.5, animations:  {
            self.cancel.alpha = 0.5
        })
    }
    
    var route = MKRoute()
    let colors = Colors()
    var lManager = CLLocationManager()
    var currentService = ServiceModel()
    var serviceHandler = ServiceHandler()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        cancel.isEnabled = true
        self.cancel.alpha = 1.0
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.backBarButtonItem?.title = "home"
        navigationController?.viewControllers = [(navigationController?.viewControllers.first)!, (navigationController?.viewControllers.last)!]
        // Set Location manager
        lManager.delegate = self
        lManager.desiredAccuracy = kCLLocationAccuracyBest
        lManager.distanceFilter = 5
        lManager.requestWhenInUseAuthorization()
        lManager.startUpdatingLocation()

        serviceTitle.text = currentService.address

        let span = MKCoordinateSpanMake(0.32, 0.32)
        let region = MKCoordinateRegionMake((lManager.location?.coordinate)!, span)
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        
        
        configureColors()
        // Do any additional setup after loading the view.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        
        drawRoute(currentLocation: userLocation)

        
    }
    
    
    func checkForCompletion(distanceInMiles: Double) {
        print(distanceInMiles)
        print(currentService.range)
        if (distanceInMiles <= currentService.range) {
            serviceHandler.fire()
            cancel.isEnabled = false
            UIView.animate(withDuration: 0.5, animations:  {
                self.cancel.alpha = 0.5
            })
            lManager.stopUpdatingLocation()
            navigationItem.setHidesBackButton(false, animated: true)
        }
    }
    
    
    
    func drawRoute(currentLocation: CLLocation){
        let sourceLocation = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: currentService.destination.latitude, longitude: currentService.destination.longitude)
        
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
            
            self.route = response.routes[0]
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.add((self.route.polyline), level: MKOverlayLevel.aboveRoads)
            
            //set dist label
            let distanceInMeters = self.route.distance
            let distanceInMilesDouble = (distanceInMeters / 1609.344).roundTo(places: 2)
            let distanceInMiles = String(distanceInMilesDouble)
            let distLabel = "\(distanceInMiles) mile(s)"
            self.distToDest.text = distLabel
            
            let timeInSeconds = self.route.expectedTravelTime
            if timeInSeconds < 59.0 {
                let timeString = String(timeInSeconds)
                let timeLabel = "\(timeString) second(s)"
                self.timeToDest.text = timeLabel
            } else {
                let timeInMin = round((timeInSeconds/60.0))
                if timeInMin >= 60.0 {
                    let minutes = Int(timeInMin.truncatingRemainder(dividingBy: 60))
                    let hours = Int(timeInMin/60)
                    let timeLabel = "\(hours) hour(s) \(minutes) minute(s)"
                    self.timeToDest.text = timeLabel
                } else {
                    let timeLabel = "\(timeInMin) minutes"
                    self.timeToDest.text = timeLabel
                }
                self.checkForCompletion(distanceInMiles: distanceInMilesDouble)
            }
            
            
            let testRectSize: MKMapSize = MKMapSize(width: self.route.polyline.boundingMapRect.size.width * 1.06, height: self.route.polyline.boundingMapRect.size.height * 1.06)
            let testRect = MKMapRect(origin: self.route.polyline.boundingMapRect.origin, size: testRectSize)
            
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
    
    func setServiceForSegue(service: ServiceModel) {
        currentService = service
        serviceHandler = ServiceHandler(currentService)
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
