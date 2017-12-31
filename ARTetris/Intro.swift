//
//  Intro.swift
//  ARTetris
//
//  Created by Michael Tang on 12/30/17.
//  Copyright © 2017 Michael Tang. All rights reserved.
//

import UIKit

class Intro: UIViewController {

  
    @IBOutlet weak var wallpaper: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1.0, animations: {
            self.wallpaper.alpha = 1
        })
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
