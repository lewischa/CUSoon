//
//  ConfirmServiceViewController.swift
//  CUSoon
//
//  Created by Jeremy Olsen on 4/22/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ConfirmServiceViewController: UIViewController {
    
    var service: ServiceModel? = nil
    let colors = Colors()

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var serviceType: UILabel!
    @IBOutlet weak var range: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phone: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for sView in view.subviews{
            for v in sView.subviews{
                v.backgroundColor = colors.background
            }
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colors.titleOrage]
        view.backgroundColor = colors.background
        
        if (service?.service_type)! > 0{
            //Service includes messaging, update labels
            setMessageServiceLabels()
        }
        else{
            //Alarm only, hide labels associated with messaging information
            hideMessageLabels()
        }
        
        //Set remaining labels
        setLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmServiceButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: "confirmToStatusSegue", sender: nil)
    }
    func setLabels(){
        //Retrieve address for given coordinates
        service?.reverseGeocode(completion: {
            (addressToUse) -> Void in
            self.address.text = addressToUse
        })
        
        //Determine service type and update label accordingly
        if service?.service_type == 0{
            serviceType.text = "Alarm only"
        }
        else if service?.service_type == 1 {
            serviceType.text = "Message only"
        }
        else{
            serviceType.text = "Alarm & Message"
        }
        
        //Show activation distance
        range.text = (service?.range.description)! + " mi"
    }
    
    func setMessageServiceLabels(){
        contact.text = service?.name
        phone.text = service?.phone
    }
    
    func hideMessageLabels(){
        contactName.alpha = 0
        contact.alpha = 0
        phoneLabel.alpha = 0
        phone.alpha = 0
    }
    
    func useServiceModel(serviceModel: ServiceModel){
        service = serviceModel
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let status = segue.destination as! StatusViewController
        
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
