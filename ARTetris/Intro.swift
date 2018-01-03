//
//  Intro.swift
//  ARTetris
//
//  Created by Michael Tang on 12/30/17.
//  Copyright © 2017 Michael Tang. All rights reserved.
//

import UIKit

class Intro: UIViewController, UIScrollViewDelegate {

    let screenWidth:CGFloat = UIScreen.main.bounds.width
    let screenHeight:CGFloat = UIScreen.main.bounds.height
  
    @IBOutlet weak var wallpaper: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animate()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUpScrollView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpScrollView() -> Void {
        /*Page dots*/
        
//        let scrollView:UIScrollView = UIScrollView(frame: self.view.bounds-60)
//        scrollView.contentSize = CGSize(width: screenWidth*2, height: screenHeight)
//        scrollView.isPagingEnabled = true
//        
//        let leftRight = UIImageView(image: UIImage(named: "leftright"))
//        leftRight.frame = CGRect(x: screenWidth*1.5 - leftRight.frame.width/2, y: 20, width: leftRight.frame.width, height: leftRight.frame.height)
//        let rotate = UIImageView(image: UIImage(named: "rotate"))
//        
//        rotate.frame = CGRect(x: screenWidth*1.5 - leftRight.frame.width/2, y: leftRight.frame.height+20, width: leftRight.frame.width, height: leftRight.frame.height)
//        
//        scrollView.addSubview(leftRight)
//        scrollView.addSubview(rotate)
//        self.view.addSubview(scrollView)
    }

    func animate() -> Void {
        UIView.animate(withDuration: 1.0, animations: {
            self.wallpaper.alpha = 1
        })
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
