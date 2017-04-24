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

    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var phones: UIScrollView!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = colors.background
        contactImage.backgroundColor = colors.background
//        stackView.alpha = 0
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colors.titleOrage]
        print(contact)
        edit.layer.cornerRadius = edit.frame.width/2
        loadData()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editContact(_ sender: Any) {
        let contactStore = CNContactStore()
        let contactInfo = CNContactViewController(for: self.contact!)
        contactInfo.present(self, animated: true, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        contactInfo.contactStore = contactStore
        contactInfo.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        contactInfo.allowsEditing = true
        contactInfo.allowsActions = true
        contactInfo.delegate = self
//        self.navigationController?.addChildViewController(contactInfo)
//        self.present(self.navigationController!, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(contactInfo, animated: true)
        
        self.stackView.subviews.forEach({$0.removeFromSuperview()})
//        do{
//            try self.contact = contactStore.unifiedContact(withIdentifier: (self.contact?.identifier)!, keysToFetch: [CNContactPhoneNumbersKey as CNKeyDescriptor])}
//        catch{
//            
//        }
//        self.contact.
        self.loadData()
    }
    
    
    func loadData(){
        if let image = contact?.imageData{
            contactImage.image = UIImage(data: image)
        }
        else{
            contactImage.image = #imageLiteral(resourceName: "contact_stock_image")
        }
        
        contactImage.layer.cornerRadius = contactImage.frame.height/2
        contactLabel.text = (contact?.givenName)! + " " + (contact?.familyName)!
        var maxWidth: CGFloat = 0
        stackView.frame = CGRect(x: 0, y: 0, width: phones.frame.width, height: 0)
        var stackHeight: CGFloat = 0.0
        for phone in (contact?.phoneNumbers)!{
//            let labelValue = phone.value as CNPhoneNumber
            let label = UILabel()
            var title = ""
//            label.text = phone.value(forKey: "label") as? String
//            label.text = labelValue.label! + ":"
            if phone.label == CNLabelPhoneNumberMobile{
                
            }
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
            label.text = title + ":"
            label.textAlignment = .right
            label.textColor = colors.titleOrage
            label.font = UIFont(name: "AgencyFB-Reg", size: 24)
//            label.frame = CGRect(x: 0, y: 0, width: 120, height: 25)
            label.sizeToFit()
            
            var num = phone.value as CNPhoneNumber
            print(num)
//            label.text = num.value(forKey: "label") as? String
            var phoneButton = UIButton(type: UIButtonType.system)
            phoneButton.setTitle(num.value(forKey: "digits") as? String, for: .normal)
            phoneButton.setTitleColor(colors.blueText, for: .normal)
            phoneButton.titleLabel?.font = UIFont(name: "AgencyFB-Reg", size: 24)
            phoneButton.frame = (phoneButton.titleLabel?.frame)!
            phoneButton.addTarget(self, action: #selector(selectNumber), for: .touchUpInside)
            print(phoneButton.frame.size)
            
            
            var horizontalStack = UIStackView(arrangedSubviews: [label, phoneButton])
            horizontalStack.axis = .horizontal
            horizontalStack.distribution = .equalSpacing
            horizontalStack.spacing = 5
            horizontalStack.sizeToFit()
            if horizontalStack.frame.width > maxWidth{
                maxWidth = horizontalStack.frame.width
            }
//            view.addSubview(phoneButton)
            
             stackHeight += horizontalStack.frame.height
            stackView.addArrangedSubview(horizontalStack)
//            stackView.sizeToFit()
        }
        stackView.frame = CGRect(x: 0, y: 0, width: maxWidth, height: stackHeight)
        
    }
    
    func useServiceModelContact(_ service: ServiceModel, _ contact: CNContact){
        self.service = service
        self.contact = contact
    }
    
    @IBAction func selectNumber(_ sender: UIButton){
        print(sender.titleLabel?.text)
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
