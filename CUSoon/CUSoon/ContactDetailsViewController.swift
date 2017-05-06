//
//  ContactDetailsViewController.swift
//  CUSoon
//
//  Created by Jeremy Olsen on 4/22/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactDetailsViewController: UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate{
    
    let colors = Colors()
    var service: ServiceModel? = nil
    var contact: CNContact? = nil

    @IBOutlet weak var contactsButton: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var phones: UIScrollView!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.background
        contactImage.backgroundColor = colors.background
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colors.titleOrage]
        edit.layer.cornerRadius = edit.frame.width/2
        contactsButton.layer.cornerRadius = edit.frame.width/2
        loadData()
        addCancelButton()
    }
    
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
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTarget), for: .touchUpInside)
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.rightBarButtonItem = cancelBarButton
        
    }
    
    func cancelButtonTarget() {
        var cancelMessage = String()
        var viewControllers = [UIViewController]()
        if service?.addingFromFavorites == true {
            cancelMessage = "This will bring you back to favorites."
            viewControllers.append((self.navigationController?.viewControllers[0])!)
            viewControllers.append((self.navigationController?.viewControllers[1])!)
        } else {
            cancelMessage = "This will bring you back home."
            viewControllers.append((self.navigationController?.viewControllers[0])!)
        }
        let alert = UIAlertController(title: "Are you sure?", message: cancelMessage, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "I'm Sure", style: .destructive, handler: {(action) in
            self.navigationController?.setViewControllers(viewControllers, animated: true)
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
    @IBAction func changeContact(_ sender: Any) {
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
        self.stackView.subviews.forEach({$0.removeFromSuperview()})
        self.loadData()
    }
    
    @IBAction func editContact(_ sender: Any) {
        let contactStore = CNContactStore()
        let contactInfo = CNContactViewController(for: self.contact!)
        contactInfo.contactStore = contactStore
        contactInfo.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        contactInfo.allowsEditing = true
        contactInfo.allowsActions = false
        contactInfo.delegate = self
//        contactInfo.present(self, animated: true, completion: {self.loadData()})
        self.navigationController?.pushViewController(contactInfo, animated: true)
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
        //Only the case if the contact information has been edited, allow changes to happen to parent view controller
        if contact != nil && contact != self.contact{
            self.stackView.subviews.forEach({$0.removeFromSuperview()})
            self.contact = contact
            self.loadData()
        }
        
    }
    
    
    func loadData(){
        
        //Check if there is an image related to the contact
        if let image = contact?.imageData{
            contactImage.image = UIImage(data: image)
        }
            //if not, provide stock image
        else{
            contactImage.image = #imageLiteral(resourceName: "contact_stock_image")
        }
        
        //Set the contact image to a round image
        contactImage.layer.cornerRadius = contactImage.frame.height/2
        
        //Start collecting user name
        var name = ""
        if let first = contact?.givenName{
            name += first
        }
        
        if let last = contact?.familyName{
            name += " " + last
        }
        contactLabel.text = name
        
        var maxWidth: CGFloat = 0
        stackView.frame = CGRect(x: 0, y: 0, width: phones.frame.width, height: 0)
        var stackHeight: CGFloat = 0.0
        if let numbers = contact?.phoneNumbers{
            for phone in numbers{
                let label = UILabel()
                var title = ""
                if phone.label == CNLabelPhoneNumberMobile{
                    
                }
                if phone.label != nil{
                switch (phone.label)!{
                    case CNLabelPhoneNumberMobile:
                        title = "mobile"
                        break
                    case CNLabelHome:
                        title = "home"
                        break
                    case CNLabelWork:
                        title = "work"
                        break
                    default:
                        title = "other"
                    }
                }
                else{
                    title = "other"
                }
                label.text = title + ":"
                label.textAlignment = .right
                label.textColor = colors.titleOrage
                label.font = UIFont(name: "AgencyFB-Reg", size: 24)
    //            label.frame = CGRect(x: 0, y: 0, width: 120, height: 25)
                label.sizeToFit()
                
                let num = phone.value as CNPhoneNumber
                print(num)
    //            label.text = num.value(forKey: "label") as? String
                let phoneButton = UIButton(type: UIButtonType.system)
                phoneButton.setTitle(num.value(forKey: "digits") as? String, for: .normal)
                phoneButton.setTitleColor(colors.blueText, for: .normal)
                phoneButton.titleLabel?.font = UIFont(name: "AgencyFB-Reg", size: 24)
                phoneButton.frame = (phoneButton.titleLabel?.frame)!
                phoneButton.addTarget(self, action: #selector(selectNumber), for: .touchUpInside)
                print(phoneButton.frame.size)
                
                
                let horizontalStack = UIStackView(arrangedSubviews: [label, phoneButton])
                horizontalStack.axis = .horizontal
                horizontalStack.distribution = .equalSpacing
                horizontalStack.spacing = 5
                horizontalStack.sizeToFit()
                if horizontalStack.frame.width > maxWidth{
                    maxWidth = horizontalStack.frame.width
                }
                
                 stackHeight += horizontalStack.frame.height
                stackView.addArrangedSubview(horizontalStack)
            }
        }
        stackView.frame = CGRect(x: 0, y: 0, width: maxWidth, height: stackHeight)
        
    }
    
    func useServiceModelContact(_ service: ServiceModel, _ contact: CNContact){
        self.service = service
        self.contact = contact
    }
    
    @IBAction func selectNumber(_ sender: UIButton){
        self.service?.phone = sender.titleLabel?.text
        self.service?.name = self.contactLabel.text
        self.performSegue(withIdentifier: "contactToConfirm", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let confirmVC = segue.destination as! ConfirmServiceViewController
        confirmVC.useServiceModel(serviceModel: self.service!)
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
