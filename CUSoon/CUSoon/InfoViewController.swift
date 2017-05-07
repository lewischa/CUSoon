//
//  InfoViewController.swift
//  CUSoon
//
//  Created by Jeremy Olsen on 5/7/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    let colors = Colors()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.background
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
