//
//  ViewController.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/12/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let accessor = DatabaseAccessor()
    var statusAvailable = true
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        view.backgroundColor = backgroundColor
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.isTranslucent = false
        // MARK: - Delete All
//        accessor.dropTable()
        
        
        /*
            Set up initial database entries
        */
        let serv1 = ServiceModel(lat: 38.472681, long: -122.760275, _range: 5.0, sType: 0, _title: "Test1", msg: "msg1", _phone: "7072922477", _name: "Chad1")
        let serv2 = ServiceModel(lat: 38.338003, long: -122.673809, _range: 5.0, sType: 1, _title: "Test2", msg: "msg2", _phone: "7072922477", _name: "SSU1")
        let serv3 = ServiceModel(lat: 37.787573, long: -122.437249, _range: 10.0, sType: 1, _title: "Test3", msg: "msg3", _phone: "7072922477", _name: "SF1")
        
        /*
           deactivate status button if no services are running
         */
        if statusAvailable == false {
            deactivateStatusButton()
        }
        
        /*
            Insert entities into database
        */
        accessor.save(service: serv1)
        accessor.save(service: serv2)
        accessor.save(service: serv3)
        
        
        /*
            Fetch all from database
        */
        var services: [ServiceModel]
        
        services = accessor.fetch()
        
        
        /*
            Print all
        */
        for service in services {
            service.printService()
        }
        
        /*
            serv4 used for update and delete testing
        */
        let serv4 = ServiceModel(lat: 1.787573, long: -122.437249, _range: 10.0, sType: 1, _title: "Test3", msg: "msg3", _phone: "7777777777", _name: "SF100000000000")
        
        updateTest(old1: serv3, new1: serv4)
        deleteTest(toDelete: serv4)
    }
    
    func deactivateStatusButton() {
            statusButton.isEnabled = false
            statusButton.tintColor = UIColor.gray
            statusLabel.textColor = UIColor.gray
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func serviceFavoritesOnClick(_ sender: Any) {
        print("serviceFavorites click")
    }
    @IBAction func serviceUpdatesOnClick(_ sender: Any) {
        print("serviceUpdates click")
        //temporarily change availability when clicked
    }

    @IBAction func newServiceOnClick(_ sender: Any) {
        print("newService click")
    }

}

