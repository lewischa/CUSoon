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
    var isConfirmToStatusButton = true

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var serviceType: UILabel!
    @IBOutlet weak var range: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var addToFavorites: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    
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
        if service?.addingFromFavorites == true || service?.isFavorite == true {
            if service?.addingFromFavorites == true && service?.isFavorite != true{
                isConfirmToStatusButton = false
                let saveImage = UIImage(imageLiteralResourceName: "saveinfo")
                let greenSaveImage = saveImage.withRenderingMode(.alwaysTemplate)
                confirmButton.setImage(greenSaveImage, for: .normal)
                confirmButton.tintColor = colors.limeGreenButton
                addCancelButton()
            }
            addToFavorites.isEnabled = false
            addToFavorites.alpha = 0
        } else {
            addToFavorites.isEnabled = true
            addToFavorites.alpha = 1
            addCancelButton()
        }
        
        
//        addCancelButton()
    }
    
    
//    func addNewFavoriteButton() {
//        let addButton = UIButton(type: .custom)
//        addButton.setImage(#imageLiteral(resourceName: "alarm_text_icon_save"), for: .normal)
//        let navBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height * 0.75
//        addButton.frame = CGRect(x: 0, y: 0, width: navBarHeight, height: navBarHeight)
//        addButton.addTarget(self, action: #selector(FavoritesTableViewController.addNewFavorite(_:)), for: .touchUpInside)
//        let addButtonNavItem = UIBarButtonItem(customView: addButton)
//        self.navigationItem.setRightBarButton(addButtonNavItem, animated: true)
//    }
    
    func addCancelButton() {
        let cancelLabel = UILabel()
        let cancelButton = UIButton(type: .custom)
        cancelLabel.text = "Cancel"
        cancelLabel.font = UIFont(name: "Agency_FB", size: 25)
        cancelLabel.textColor = colors.blueText
        cancelLabel.textAlignment = .right
        cancelLabel.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)! * 0.25, height: (self.navigationController?.navigationBar.frame.height)! * 0.65)
        cancelButton.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)! * 0.25, height: (self.navigationController?.navigationBar.frame.height)! * 0.65)
//        cancelButton.addSubview(cancelLabel)
//        cancelLabel.layer.borderWidth = 1
        cancelLabel.layer.borderColor = colors.blueText.cgColor
//        cancelLabel.layer.cornerRadius = 5
        cancelButton.addSubview(cancelLabel)
        cancelButton.addTarget(self, action: #selector(ConfirmServiceViewController.cancelButtonTarget), for: .touchUpInside)
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.rightBarButtonItem = cancelBarButton
        
    }
    
    func cancelButtonTarget() {
        if service?.addingFromFavorites == true || service?.isFavorite == true {
            let favoritesVC = self.navigationController?.viewControllers[1]
            self.navigationController?.popToViewController(favoritesVC!, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmServiceButtonClick(_ sender: UIButton) {
        if !isConfirmToStatusButton {
            let saveAndUseAction = UIAlertAction(title: "Save & Use", style: .default, handler: {(action) in
                self.service?.saveToFavorites()
                self.isConfirmToStatusButton = true
                self.performSegue(withIdentifier: "confirmToStatusSegue", sender: nil)
            })
            let saveOnlyAction = UIAlertAction(title: "Save Only", style: .default, handler: {(action) in
                self.service?.saveToFavorites()
                self.isConfirmToStatusButton = true
//                self.navigationItem.backBarButtonItem?.title = "Home"
                var viewControllers = [UIViewController]()
                viewControllers.append((self.navigationController?.viewControllers[0])!)
                viewControllers.append((self.navigationController?.viewControllers[1])!)
                viewControllers.append((self.navigationController?.viewControllers.last)!)
                self.navigationController?.setViewControllers(viewControllers, animated: true)
                UIView.animate(withDuration: 0.5, animations: {
                    sender.alpha = 0.0
                }, completion: {(completed) in
                    sender.setImage(#imageLiteral(resourceName: "nextbutton"), for: .normal)
                    self.navigationItem.backBarButtonItem?.title = "Favorites"
                    UIView.animate(withDuration: 0.5, animations: {
                        sender.alpha = 1.0
                    }, completion: nil)
                })
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let alert = UIAlertController(title: "Save Service", message: "Save and use, or save only?", preferredStyle: .alert)
            alert.addAction(saveAndUseAction)
            alert.addAction(saveOnlyAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "confirmToStatusSegue", sender: nil)
        }
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
        if segue.identifier == "confirmToStatusSegue" {
            let status = segue.destination as! StatusViewController
            status.setServiceForSegue(service: service!)
        }
        
    }
    
    
    @IBAction func addServiceToFavorites(_ sender: Any) {
        let saveAction = UIAlertAction(title: "Ok", style: .default, handler: {(action) in
            self.service?.saveToFavorites()
            self.addToFavorites.isEnabled = false
            self.addToFavorites.alpha = 0.5
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "Save Service", message: "Save \(service!.title!) to favorites?", preferredStyle: .alert)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
