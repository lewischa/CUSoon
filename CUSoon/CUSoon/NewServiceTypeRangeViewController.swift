//
//  NewServiceTypeRangeViewController.swift
//  CUSoon
//
//  Created by Jeremy Olsen on 4/15/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit

class NewServiceTypeRangeViewController: UIViewController {
    var range: Double = 10.0

    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        
        slider.value = Float(range)
        rangeLabel.text = String(range) + " miles"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSlide(_ sender: Any) {
        if (slider.value - slider.value.rounded()) < 0{
            range = Double(slider.value.rounded()) - 0.5}
        else{
            range = Double(slider.value.rounded())
        }
        rangeLabel.text = String(range) + " miles"
        print("range:\(range)")
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
