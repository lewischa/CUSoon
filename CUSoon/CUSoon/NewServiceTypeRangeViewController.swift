//
//  NewServiceTypeRangeViewController.swift
//  CUSoon
//
//  Created by Jeremy Olsen on 4/15/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts
import ContactsUI

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class NewServiceTypeRangeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, CNContactPickerDelegate, CNContactViewControllerDelegate{

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mapPlace: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var services: UISegmentedControl!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    let colors = Colors()
    var range: Double = 10.0
    var lManager = CLLocationManager()
    var selectedPin: MKPlacemark? = nil
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var service: ServiceModel? = nil
    var saving = false
    let contactStore = CNContactStore.init()
    var contact: CNContact? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colors.titleOrage]
        view.backgroundColor = colors.background
        navBar.backgroundColor = colors.background
        navBar.barTintColor = colors.background
        
        slider.value = Float(range)
        rangeLabel.text = String(range) + " miles"
        
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
        
        updateNextButtonSettings()
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNextButtonSettings(){
        if selectedPin == nil{
            nextButton.alpha = 0.5
            nextButton.isUserInteractionEnabled = false
        }
        else{
            nextButton.alpha = 1
            nextButton.isUserInteractionEnabled = true
        }
    }
    
    func useServiceModel(_ service: ServiceModel){
        self.service = service
    }
    
    @IBAction func onNextClick(_ sender: Any) {
        //If nil, no data collected yet. Collect data for segue
        if service == nil{
            print("service available")
            service = ServiceModel(dest: (selectedPin?.coordinate)!, _range: range, sType: Int16(services.selectedSegmentIndex), _title: "", msg: "", _phone: "", _name: "")
        }
            //Data collected, but user came back and made possible changes, update info
        else{
            service?.destination = (selectedPin?.coordinate)!
            service?.range = range
            service?.service_type = Int16(services.selectedSegmentIndex)
        }
        
        print(services.selectedSegmentIndex)
        // If set to anything other than alarm service, collect contact info
        if services.selectedSegmentIndex > 0{
            let entity = CNEntityType.contacts
            let authStatus = CNContactStore.authorizationStatus(for: entity)
            
            if authStatus == CNAuthorizationStatus.notDetermined{
                
                contactStore.requestAccess(for: entity, completionHandler: { (success, nil) in
                    if success{
                        self.openContacts()
                    }
                })
            }
            else if authStatus == CNAuthorizationStatus.authorized{
                self.openContacts()
            }
            else{
                print("not authorized")
            }
        }
            //Segue to confirmation page
        else{
            self.performSegue(withIdentifier: "confirmService", sender: nil)
        }
    }
    
    func openContacts(){
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true){
            
        }
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        self.contact = contact
        self.performSegue(withIdentifier: "contactInfo", sender: nil)
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        defer{navigationController?.popViewController(animated: true)}

    }
    
    
    
    func save(){
            self.saving = true
    }
    

    @IBAction func onSlide(_ sender: Any) {
        if (slider.value - slider.value.rounded()) < 0{
            range = Double(slider.value.rounded()) - 0.5}
        else{
            range = Double(slider.value.rounded())
        }
        rangeLabel.text = String(range) + " miles"
        print("range:\(range)")
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    @IBAction func showSearchBar(_ sender: Any) {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController.searchResultsUpdater = locationSearchTable
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        self.searchController.searchBar.delegate = self
        
        
        present(searchController, animated: true, completion: nil)
    }
    //Allows user to shake device to reset values with shake gesture
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            range = 10.0
            rangeLabel.text = String(range) + " miles"
            slider.value = Float(range)
            services.selectedSegmentIndex = 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmService"{
            let confirmService = segue.destination as! ConfirmServiceViewController
            confirmService.useServiceModel(serviceModel: service!)
        }
        else{
            let contactDet = segue.destination as! ContactDetailsViewController
           contactDet.useServiceModelContact(service!, contact!)
        }
        
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if let placemark = localSearchResponse?.mapItems[0].placemark{
                self.dropPinZoomIn(placemark: placemark)
            }
        }
    }

}


extension NewServiceTypeRangeViewController: HandleMapSearch{
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.title
        if let city = placemark.locality, let state = placemark.administrativeArea{
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        updateNextButtonSettings()
    }
}
