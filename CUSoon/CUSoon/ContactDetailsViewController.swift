//
//  ContactDetailsViewController.swift
//  CUSoon
//
//  Created by Jeremy Olsen on 4/22/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit
import Contacts

class ContactDetailsViewController: UIViewController {
    
    let colors = Colors()
    var service: ServiceModel? = nil
    var contact: CNContact? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = colors.background
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colors.titleOrage]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func useServiceModelContact(_ service: ServiceModel, _ contact: CNContact){
        self.service = service
        self.contact = contact
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
