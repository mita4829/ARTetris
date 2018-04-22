//
//  BlockFactory.swift
//  ARTetris
//
//  Created by Michael Tang on 12/24/17.
//  Copyright © 2017 Michael Tang. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

//Teteromino size
let BOX_SIZE:Float = 0.05
let ROUNDNESS:Float = 0.005 //Chamfer radius
//Colors for tetrominoes
let PINK = UIColor(red:1.00, green:0.27, blue:0.67, alpha:1.0) //7
let RED = UIColor(red:1.00, green:0.26, blue:0.29, alpha:1.0)  //1
let ORANGE = UIColor(red:1.00, green:0.61, blue:0.23, alpha:1.0)//2
let YELLOW = UIColor(red:1.00, green:0.80, blue:0.23, alpha:1.0)//3
let BLUE = UIColor(red:0.31, green:0.81, blue:1.0, alpha:1.0)//4
let PURPLE = UIColor(red:0.31, green:0.47, blue:1.0, alpha:1.0)//5
let GRAY = UIColor(red:0.70, green:0.70, blue:0.75, alpha:1.0)//6
let PLANE = UIColor(red:1, green:1, blue:1, alpha:0)

/* Abstract Factory pattern to work */
class BlockFactory{
    let redBlock:SCNNode = SCNNode(geometry: SCNBox(width: CGFloat(BOX_SIZE), height: CGFloat(BOX_SIZE), length: CGFloat(BOX_SIZE), chamferRadius: CGFloat(ROUNDNESS)))
    let pinkBlock:SCNNode = SCNNode(geometry: SCNBox(width: CGFloat(BOX_SIZE), height: CGFloat(BOX_SIZE), length: CGFloat(BOX_SIZE), chamferRadius: CGFloat(ROUNDNESS)))
    let orangeBlock:SCNNode = SCNNode(geometry: SCNBox(width: CGFloat(BOX_SIZE), height: CGFloat(BOX_SIZE), length: CGFloat(BOX_SIZE), chamferRadius: CGFloat(ROUNDNESS)))
    let yellowBlock:SCNNode = SCNNode(geometry: SCNBox(width: CGFloat(BOX_SIZE), height: CGFloat(BOX_SIZE), length: CGFloat(BOX_SIZE), chamferRadius: CGFloat(ROUNDNESS)))
    let blueBlock:SCNNode = SCNNode(geometry: SCNBox(width: CGFloat(BOX_SIZE), height: CGFloat(BOX_SIZE), length: CGFloat(BOX_SIZE), chamferRadius: CGFloat(ROUNDNESS)))
    let purpleBlock:SCNNode = SCNNode(geometry: SCNBox(width: CGFloat(BOX_SIZE), height: CGFloat(BOX_SIZE), length: CGFloat(BOX_SIZE), chamferRadius: CGFloat(ROUNDNESS)))
    let grayBlock:SCNNode = SCNNode(geometry: SCNBox(width: CGFloat(BOX_SIZE), height: CGFloat(BOX_SIZE), length: CGFloat(BOX_SIZE), chamferRadius: CGFloat(ROUNDNESS)))
    
    
    func RedBlock() -> SCNNode {
        redBlock.geometry?.firstMaterial?.diffuse.contents = RED
        return redBlock.clone()
    }
    func PinkBlock() -> SCNNode {
        pinkBlock.geometry?.firstMaterial?.diffuse.contents = PINK
        return pinkBlock.clone()
    }
    func OrangeBlock() -> SCNNode {
        orangeBlock.geometry?.firstMaterial?.diffuse.contents = ORANGE
        return orangeBlock.clone()
    }
    func YellowBlock() -> SCNNode {
        yellowBlock.geometry?.firstMaterial?.diffuse.contents = YELLOW
        return yellowBlock.clone()
    }
    func BlueBlock() -> SCNNode {
        blueBlock.geometry?.firstMaterial?.diffuse.contents = BLUE
        return blueBlock.clone()
    }
    func PurpleBlock() -> SCNNode {
        purpleBlock.geometry?.firstMaterial?.diffuse.contents = PURPLE
        return purpleBlock.clone()
    }
    func GrayBlock() -> SCNNode {
        grayBlock.geometry?.firstMaterial?.diffuse.contents = GRAY
        return grayBlock.clone()
    }
}


