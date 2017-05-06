//
//  ViewController.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/12/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let accessor = DatabaseAccessor()
    let locator = CLLocationManager()
    let colors = Colors()
    @IBOutlet weak var newServiceButton: UIButton!
    @IBOutlet weak var newServiceLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    var currentService = ServiceModel(lat: 38.472681, long: -122.760275, _range: 5.0, sType: 0, _title: "Test1", msg: "msg1", _phone: "7072922477", _name: "Chad1")

    override func viewDidLoad() {
        super.viewDidLoad()
        locator.requestAlwaysAuthorization()
        // Do any additional setup after loading the view, typically from a nib.
        let backgroundColor = colors.background
        view.backgroundColor = backgroundColor
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.isTranslucent = false
        // MARK: - Delete All
//        accessor.dropTable()
        initializeDatabase()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if accessor.isServiceRunning() {
//            activateStatusButton()
//            deactivateNewAndFavoritesButtons()
//        } else {
//            deactivateStatusButton()
//            activateNewAndFavoritesButtons()
//        }
    }
    
    func activateNewAndFavoritesButtons() {
        newServiceButton.isEnabled = true
        newServiceButton.alpha = 1
        newServiceLabel.textColor = colors.titleOrage
        favoritesButton.isEnabled = true
        favoritesButton.alpha = 1
        favoritesLabel.textColor = colors.titleOrage
        
    }
    
    func deactivateNewAndFavoritesButtons() {
        newServiceButton.isEnabled = false
        newServiceButton.alpha = 0.5
        newServiceLabel.textColor = UIColor.gray
        favoritesButton.isEnabled = false
        favoritesButton.alpha = 0.5
        favoritesLabel.textColor = UIColor.gray
    }
    
    func activateStatusButton() {
        statusButton.isEnabled = true
        statusButton.alpha = 1
        statusLabel.textColor = colors.titleOrage
    }
    func deactivateStatusButton() {
        statusButton.isEnabled = false
        statusButton.alpha = 0.5
        statusLabel.textColor = UIColor.gray
    }
    
    func initializeDatabase() {
        accessor.insertServiceRunning()
    }

    
    
    // MARK: - Test Delete
    /*
        Tester function for deleting entity from database
    */
    func deleteTest(toDelete: ServiceModel) {
        print("DELETE FUNCTION CALLED")
        print("")
        print("Services before delete: ")
        print("")
        var services: [ServiceModel]
        services = accessor.fetch()
        for service in services {
            service.printService()
        }
        print("")
        print("DELETING FOLLOWING: ")
        toDelete.printService()
        print("")
        accessor.delete(service: toDelete)
        print("SERVICES AFTER DELETE: ")
        print("")
        services = accessor.fetch()
        for service in services {
            service.printService()
        }
    }
    
    // MARK: - Test Update
    /*
        Tester function for updating entity in database
    */
    func updateTest(old1: ServiceModel, new1: ServiceModel) {
        print("")
        print("UPDATE FUNCTION CALLED")
        
        var services: [ServiceModel]
        services = accessor.fetch()
        for service in services {
            service.printService()
        }
        
        print("TESTING UPDATE")
        print("")
        print("UPDATING FOLLOWING: ")
        old1.printService()
        print("")
        print("TO: ")
        print("")
        new1.printService()
        print("")
        
        accessor.update(old: old1, new: new1)
        
        services = accessor.fetch()
        print("PRINTING AFTER UPDATE")
        for service in services {
            service.printService()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.title = "Home"
        
        backButton.tintColor = UIColor(red: 0/255, green: 255/255, blue: 204/255, alpha: 1)
        navigationItem.backBarButtonItem = backButton
        
        if segue.identifier == "serviceSegue"{
            let statusVC = segue.destination as! StatusViewController
            statusVC.setServiceForSegue(service: currentService)    
        }
        
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func serviceFavoritesOnClick(_ sender: Any) {
//        print("serviceFavorites click")
    }
    @IBAction func serviceUpdatesOnClick(_ sender: Any) {
//        print("serviceUpdates click")
        //temporarily change availability when clicked
    }

    @IBAction func newServiceOnClick(_ sender: Any) {
//        print("newService click")
    }

}

