//
//  FavoritesTableViewController.swift
//  CUSoon
//
//  Created by Jeremy Olsen on 4/15/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit
import AVFoundation

class FavoritesTableViewController: UITableViewController {
    
    let accessor = DatabaseAccessor()
    var serviceFavorites = [ServiceModel]()
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        
        serviceFavorites = accessor.fetch()
        
        configureColors()
        addNewFavoriteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serviceFavorites = accessor.fetch()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func configureColors() {
        let textColor = colors.titleOrage
        let backgroundColor = colors.background
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
        navigationController?.navigationBar.barTintColor = backgroundColor
        view.backgroundColor = backgroundColor
    }
    
    func addNewFavoriteButton() {
        let addButton = UIButton(type: .custom)
        addButton.setImage(#imageLiteral(resourceName: "alarm_text_icon_save"), for: .normal)
        let navBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height * 0.75
        addButton.frame = CGRect(x: 0, y: 0, width: navBarHeight, height: navBarHeight)
        addButton.addTarget(self, action: #selector(FavoritesTableViewController.addNewFavorite(_:)), for: .touchUpInside)
        let addButtonNavItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.setRightBarButton(addButtonNavItem, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addNewFavorite(_ sender: Any) {
        self.performSegue(withIdentifier: "addFavoriteSegue", sender: sender)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return serviceFavorites.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceFavoriteCell", for: indexPath)
        
        if let thisCell = cell as? FavoritesTableViewCell {
            let serviceToUse = serviceFavorites[indexPath.row]
            thisCell.useService(service: serviceToUse)
        }
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //        let cancelAction = UITableViewRowAction(style: .normal, title: "Cancel", handler: {(UITableViewRowAction, IndexPath) in
    //            self.tableView.setEditing(false, animated: true)
    //        })
    //        cancelAction.backgroundColor = UIColor.blue
    //        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(UITableViewRowAction, IndexPath) in
    //            let alert = UIAlertController(title: "Delete Service", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
    //            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
    //                self.tableView.setEditing(false, animated: true)
    //            })
    //            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {(action) in
    //                self.accessor.delete(service: self.serviceFavorites[indexPath.row])
    //                self.serviceFavorites.remove(at: indexPath.row)
    //                tableView.deleteRows(at: [indexPath], with: .fade)
    //            })
    //            alert.addAction(cancelAction)
    //            alert.addAction(deleteAction)
    //
    //            //            self.view.alpha = 0.5
    //            //            let subview = alert.view.subviews.first! as UIView
    //            //            let subview2 = subview.subviews.first! as UIView
    //            //            let alertContentView = subview2.subviews.first! as UIView
    //            //            subview2.backgroundColor = colors.background
    //            //            alertContentView.backgroundColor = colors.background
    //            self.present(alert, animated: true, completion: nil)
    //        })
    //        return [cancelAction, deleteAction]
    //    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alert = UIAlertController(title: "Delete Service", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
                self.tableView.setEditing(false, animated: true)
            })
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {(action) in
                self.accessor.delete(service: self.serviceFavorites[indexPath.row])
                self.serviceFavorites.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    AudioServicesPlaySystemSound(1001)
                }
            })
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            //            self.view.alpha = 0.5
            //            let subview = alert.view.subviews.first! as UIView
            //            let subview2 = subview.subviews.first! as UIView
            //            let alertContentView = subview2.subviews.first! as UIView
            //            subview2.backgroundColor = colors.background
            //            alertContentView.backgroundColor = colors.background
            self.present(alert, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addFavoriteSegue" {
            let newServiceVC = segue.destination as! NewServiceTypeRangeViewController
            let addingService = ServiceModel()
            addingService.addingFromFavorites = true
            newServiceVC.useServiceModel(addingService)
        }
        
        if segue.identifier == "useFavoriteSegue" {
            let cell = sender as! FavoritesTableViewCell
            if let idx = tableView.indexPath(for: cell) {
                let confirmVC = segue.destination as! ConfirmServiceViewController
                confirmVC.useServiceModel(serviceModel: serviceFavorites[idx.row])
            }
        }
    }
}
