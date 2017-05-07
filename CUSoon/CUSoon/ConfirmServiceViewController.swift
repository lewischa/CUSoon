//
//  ConfirmServiceViewController.swift
//  CUSoon
//
//  Created by:
//      Brooke Borges
//      Chad Lewis
//      Jeremy Olsen
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
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func cancelButtonTarget() {
        var viewControllerToPopTo = UIViewController()
        var cancelMessage = String()
        if service?.addingFromFavorites == true || service?.isFavorite == true {
            viewControllerToPopTo = (self.navigationController?.viewControllers[1])!
            cancelMessage = "This will bring you back to Favorites."
//            self.navigationController?.popToViewController(favoritesVC!, animated: true)
        } else {
//            self.navigationController?.popToRootViewController(animated: true)
            viewControllerToPopTo = (self.navigationController?.viewControllers[0])!
            cancelMessage = "This will bring you back home."
        }
        
        let alert = UIAlertController(title: "Are you sure?", message: cancelMessage, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "I'm Sure", style: .destructive, handler: {(action) in
            self.navigationController?.popToViewController(viewControllerToPopTo, animated: true)
        })
        let cancelAction = UIAlertAction(title: "Stay Here", style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func disableCancelButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)! * 0.25, height: (self.navigationController?.navigationBar.frame.height)! * 0.65)
        cancelButton.backgroundColor = self.colors.background
        let barButton = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @IBAction func confirmServiceButtonClick(_ sender: UIButton) {
        if !isConfirmToStatusButton {
            let alert = UIAlertController(title: "Save Service", message: "Enter a title to save or use the service.", preferredStyle: .alert)
            let saveAndUseAction = UIAlertAction(title: "Save & Use", style: .default, handler: {(action) in
                let titleTextField = alert.textFields![0] as UITextField
                self.service?.title = titleTextField.text
                self.service?.saveToFavorites()
                self.isConfirmToStatusButton = true
                self.performSegue(withIdentifier: "confirmToStatusSegue", sender: nil)
            })
            let saveOnlyAction = UIAlertAction(title: "Save Only", style: .default, handler: {(action) in
                self.disableCancelButton()
                let titleTextField = alert.textFields![0] as UITextField
                self.service?.title = titleTextField.text
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
            
            alert.addTextField(configurationHandler: {(textField) in
                textField.addTarget(self, action: #selector(self.titleTextChangedSavingFromFavorites(_:)), for: .editingChanged)
            })
            
            alert.addAction(saveAndUseAction)
            alert.addAction(saveOnlyAction)
            alert.actions[0].isEnabled = false
            alert.actions[1].isEnabled = false
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "confirmToStatusSegue", sender: nil)
        }
    }
    
    func titleTextChangedSavingFromFavorites(_ sender: Any) {
        let textField = sender as! UITextField
        var responder: UIResponder! = textField
        while !(responder is UIAlertController) {
            responder = responder.next
        }
        let alert = responder as! UIAlertController
        alert.actions[0].isEnabled = (textField.text != "")
        alert.actions[1].isEnabled = (textField.text != "")
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
        let alert = UIAlertController(title: "Save Service", message: "Enter a title to save to Favorites", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action) in
            self.disableCancelButton()
            let titleTextField = alert.textFields![0] as UITextField
            self.service?.title = titleTextField.text
            self.service?.saveToFavorites()
            self.addToFavorites.isEnabled = false
            self.addToFavorites.alpha = 0.5
            var viewControllers = [UIViewController]()
            viewControllers.append((self.navigationController?.viewControllers.first)!)
            viewControllers.append((self.navigationController?.viewControllers.last)!)
            self.navigationController?.setViewControllers(viewControllers, animated: true)
//            self.navigationItem.backBarButtonItem?.title = "Home"
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField(configurationHandler: {(textField) in
            textField.addTarget(self, action: #selector(self.titleTextChangedSavingNewService(_:)), for: .editingChanged)
        })
        alert.addAction(saveAction)
        alert.actions[0].isEnabled = false
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func titleTextChangedSavingNewService(_ sender: Any) {
        let textField = sender as! UITextField
        var responder: UIResponder! = textField
        while !(responder is UIAlertController) {
            responder = responder.next
        }
        let alert = responder as! UIAlertController
        alert.actions[0].isEnabled = (textField.text != "")
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
