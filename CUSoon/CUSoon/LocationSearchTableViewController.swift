//
//  LocationSearchTableViewController.swift
//  CUSoon
//
//  Created by:
//      Brooke Borges
//      Chad Lewis
//      Jeremy Olsen
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var matchingItem: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().background
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print("matchingItem.count: \(matchingItem.count)")
        return matchingItem.count
    }
    
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("In update table view")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItem[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.textLabel?.textColor = Colors().titleOrage
        cell.textLabel?.font = UIFont(name: "AgencyFB-Reg", size: 20)
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        cell.detailTextLabel?.textColor = Colors().blueText
        cell.detailTextLabel?.font = UIFont(name: "AgencyFB-Reg", size: 20)
        cell.backgroundColor = Colors().background

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItem[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else{return}
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start {response, _ in
            guard let response = response else{
                return
            }
            self.matchingItem = response.mapItems
//            print(self.matchingItem.count)
//            print(self.matchingItem[0])
            self.tableView.reloadData()
        }
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String{
        //Put a space between address number and street
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : " "
        
        //Put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : " "
        let addressLine = String(format: "%@%@%@%@%@%@%@",
                                 selectedItem.subThoroughfare ?? "",
                                 firstSpace,
                                 selectedItem.thoroughfare ?? "",
                                 comma,
                                 selectedItem.locality ?? "",
                                 secondSpace,
                                 selectedItem.administrativeArea ?? "")
        return addressLine
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

//extension LocationSearchTableViewController{
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return matchingItem.count
//    }
//    
//    
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        let selectedItem = matchingItem[indexPath.row].placemark
//        cell.textLabel?.text = selectedItem.name
//        cell.detailTextLabel?.text = ""
//        
//        
//        // Configure the cell...
//        
//        return cell
//    }
//}

//extension LocationSearchTableViewController : UISearchResultsUpdating{
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else{return}
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = searchBarText
//        request.region = mapView.region
//        let search = MKLocalSearch(request: request)
//        search.start {response, _ in
//            guard let response = response else{
//                return
//            }
//            self.matchingItem = response.mapItems
//            print(self.matchingItem.count)
//            print(self.matchingItem[0])
//            self.tableView.reloadData()
//        }
//    }
//}


