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
import UserNotifications

class StatusViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeToDest: UILabel!
    @IBOutlet weak var distToDest: UILabel!
    @IBOutlet weak var serviceTitle: UILabel!
    @IBOutlet weak var centerOnLocationButton: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
    @IBAction func cancelButton(_ sender: Any) {
        lManager.stopUpdatingLocation()
        navigationItem.setHidesBackButton(false, animated: true)
        cancel.isEnabled = false
        UIView.animate(withDuration: 0.5, animations:  {
            self.cancel.alpha = 0.5
        })
        mapView.removeOverlays(self.mapView.overlays)
    }
    
    var route = MKRoute()
    let colors = Colors()
    var lManager = CLLocationManager()
    var currentService = ServiceModel()
    var serviceHandler = ServiceHandler()
    var annotationSet = false
    var centeredOnUserLocation = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(gestureRecognizer:)))
        mapDragRecognizer.delegate = self
        mapView.addGestureRecognizer(mapDragRecognizer)
        UNUserNotificationCenter.current().delegate = (self as UNUserNotificationCenterDelegate)
        mapView.delegate = self
        cancel.isEnabled = true
        self.cancel.alpha = 1.0
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.backBarButtonItem?.title = "home"
        navigationController?.viewControllers = [(navigationController?.viewControllers.first)!, (navigationController?.viewControllers.last)!]
        // Set Location manager
        lManager.delegate = self
        lManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        lManager.distanceFilter = 5
        lManager.requestAlwaysAuthorization()
        lManager.allowsBackgroundLocationUpdates = true
        lManager.startUpdatingLocation()
        

        //serviceTitle.text = currentService.address
        currentService.reverseGeocode(completion: {
            (addressToUse) -> Void in
            self.serviceTitle.text = addressToUse
        })
        let span = MKCoordinateSpanMake(0.32, 0.32)
        let region = MKCoordinateRegionMake((lManager.location?.coordinate)!, span)
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        
        
        configureColors()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            centeredOnUserLocation = false
            centerOnLocationButton.alpha = 1.0
            centerOnLocationButton.isEnabled = true
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        print(userLocation)
        self.drawRoute(currentLocation: userLocation)
    }
    
    
    func checkForCompletion(distanceInMiles: Double, time: Double) {
        if (distanceInMiles <= currentService.range) {
            serviceHandler.fire(time)
            DispatchQueue.main.async {
                self.cancel.isEnabled = false
                UIView.animate(withDuration: 0.5, animations:  {
                    self.cancel.alpha = 0.5
                })
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let coordinate = MKCoordinateRegion(center: (self.lManager.location?.coordinate)!, span: span)
                self.mapView.setRegion(coordinate, animated: true)
                self.lManager.stopUpdatingLocation()
                self.navigationItem.setHidesBackButton(false, animated: true)
                self.mapView.removeOverlays(self.mapView.overlays)
            }
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
        
        if !self.annotationSet{
            self.mapView.showAnnotations([destinationAnnotation], animated: true )
            self.annotationSet = true
        }
        
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
            let timeInMin = round((timeInSeconds/60.0))
            if timeInSeconds < 59.0 {
                let timeString = String(timeInSeconds)
                let timeLabel = "\(timeString) second(s)"
                self.timeToDest.text = timeLabel
            } else {
                if timeInMin >= 60.0 {
                    let minutes = Int(timeInMin.truncatingRemainder(dividingBy: 60))
                    let hours = Int(timeInMin/60)
                    let timeLabel = "\(hours) hour(s) \(minutes) minute(s)"
                    self.timeToDest.text = timeLabel
                } else {
                    let timeLabel = "\(timeInMin) minutes"
                    self.timeToDest.text = timeLabel
                }
//                self.checkForCompletion(distanceInMiles: distanceInMilesDouble)
            }
            self.checkForCompletion(distanceInMiles: distanceInMilesDouble, time: timeInMin)
            
            
            if !self.centeredOnUserLocation {
                self.mapView.setUserTrackingMode(.none, animated: true)
                let latDelta = abs(currentLocation.coordinate.latitude - self.currentService.destination.latitude) + 0.05
                let lonDelta = abs(currentLocation.coordinate.longitude - self.currentService.destination.longitude) + 0.05
                
                let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
                
                let region = MKCoordinateRegion(center: currentLocation.midPoint(destination: self.currentService.destination), span: span)
                self.mapView.setRegion(region, animated: true)
            } else {
//                let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
//                let region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
//                self.mapView.setRegion(region, animated: true)
                self.mapView.setUserTrackingMode(.followWithHeading, animated: true)
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = colors.titleOrage
        renderer.lineWidth = 2.25
        renderer.alpha = 0.75
        
        return renderer
    }
    @IBAction func centerOnUserLocationTarget(_ sender: Any) {
        centeredOnUserLocation = true
        self.mapView.setUserTrackingMode(.followWithHeading, animated: true)
        let button = sender as! UIButton
        button.isEnabled = false
        button.alpha = 0.25
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureColors() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colors.titleOrage]
        navigationController?.navigationBar.barTintColor = colors.background
        view.backgroundColor = colors.background
        
    }
    
    func setServiceForSegue(service: ServiceModel) {
        currentService = service
        //serviceTitle.text = service.address
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


extension StatusViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
