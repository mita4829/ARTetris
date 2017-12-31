//
//  ViewController.swift
//  ARTetris
//
//  Created by Michael Tang on 12/22/17.
//  Copyright © 2017 Michael Tang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var hasCompletedFirstPlaneDetection:Bool = false
    var View:TetrisView!
    var Model:TetrisModel!
    let overlay:UIImageView = UIImageView(image: UIImage(named: "PlaneDetect"))

    let screenWidth:CGFloat = UIScreen.main.bounds.width
    let screenHeight:CGFloat = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Draw a plane view to help with finding a plane
        overlay.frame = CGRect(x: (screenWidth/2)-150, y: (screenHeight/2)-150, width: 300, height: 300)
        overlay.alpha = 0.5
        self.view.addSubview(overlay)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        //Detect natural light
        sceneView.autoenablesDefaultLighting = true

        // Set the scene to the view
        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //Event needs to be async, for the event can only run once a plane is detected.
        DispatchQueue.main.async {
            //Block future planes if one already exists
            if let planeAnchor = anchor as? ARPlaneAnchor {
                if(self.hasCompletedFirstPlaneDetection == false){
                    self.overlay.removeFromSuperview()
                    self.hasCompletedFirstPlaneDetection = true
                    let x:Float = planeAnchor.center.x + node.position.x
                    let y:Float = planeAnchor.center.y + node.position.y
                    let z:Float = planeAnchor.center.z + node.position.z
                    
                    self.View = TetrisView(sceneView: self.sceneView,origin: (x,y,z))
                    self.Model = TetrisModel(view: self.View, controller: self)
                    self.movementGuestures()
                    self.Model.startGame()
                }
            }
        }
    }
    
    func movementGuestures() -> Void {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rotate(sender:)))
        self.view.addGestureRecognizer(tap)
        
        let right:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        let left:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        
        let down:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        down.direction = .down
        self.view.addGestureRecognizer(down)
    }
    
    @objc func rotate(sender: UITapGestureRecognizer) -> Void {
        /*Tapping rotates the tetromino 90 degress clockwise*/
        self.Model.rotate()
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer) -> Void {
        self.Model.swipe(sender: sender)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
