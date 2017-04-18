//
//  FavoritesTableViewController.swift
//  CUSoon
//
//  Created by Jeremy Olsen on 4/15/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    let accessor = DatabaseAccessor()
    var serviceFavorites = [ServiceModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        
        serviceFavorites = accessor.fetch()
        
        configureColors()
        addNewFavoriteButton()
        
//        let textColor = UIColor(red: 255/255, green: 171/255, blue: 74/255, alpha: 1)
//        let backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
//        navigationController?.navigationBar.barTintColor = backgroundColor
        
        //Gray background
//        view.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func configureColors() {
        let textColor = UIColor(red: 255/255, green: 171/255, blue: 74/255, alpha: 1)
        let backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        
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
        print("Add new favorite button tapped")
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
