//
//  Intro.swift
//  ARTetris
//
//  Created by Michael Tang on 12/30/17.
//  Copyright © 2017 Michael Tang. All rights reserved.
//

import UIKit

class Intro: UIViewController {

    let screenWidth:CGFloat = UIScreen.main.bounds.width
    let screenHeight:CGFloat = UIScreen.main.bounds.height
  
    @IBOutlet weak var wallpaper: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animate()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animate() -> Void {
        UIView.animate(withDuration: 1.0, animations: {
            self.wallpaper.alpha = 1
        })
    }
}
