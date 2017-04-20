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
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegionMake((lManager.location?.coordinate)!, span)
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        
        
        
        lManager.stopUpdatingLocation()
        configureColors()
        // Do any additional setup after loading the view.
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
