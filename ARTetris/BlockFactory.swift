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
let GRAY = UIColor(red:0.60, green:0.60, blue:0.65, alpha:1.0)//6
let PLANE = UIColor(red:1, green:1, blue:1, alpha:0)

//let PINK = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0) //7
//let RED = UIColor(red:0.63, green:0.36, blue:0.34, alpha:1.0)  //1
//let ORANGE = UIColor(red:0.85, green:0.65, blue:0.49, alpha:1.0)//2
//let YELLOW = UIColor(red:0.84, green:0.83, blue:0.65, alpha:1.0)//3
//let BLUE = UIColor(red:0.28, green:0.53, blue:0.52, alpha:1.0)//4
//let PURPLE = UIColor(red:0.04, green:0.26, blue:0.34, alpha:1.0)//5
//let GRAY = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.0)//6
//let PLANE = UIColor(red:1, green:1, blue:1, alpha:0)


/* Abstract Factory pattern to work */
class BlockFactory{
    func buildBlock(color c:UIColor) -> SCNNode {
        let box:SCNNode = SCNNode(geometry: SCNBox(width: CGFloat(BOX_SIZE), height: CGFloat(BOX_SIZE), length: CGFloat(BOX_SIZE), chamferRadius: CGFloat(ROUNDNESS)))
        box.geometry?.firstMaterial?.diffuse.contents = c
        return box
    }
    func RedBlock() -> SCNNode {
        return buildBlock(color: RED)
    }
    func PinkBlock() -> SCNNode {
        return buildBlock(color: PINK)
    }
    func OrangeBlock() -> SCNNode {
        return buildBlock(color: ORANGE)
    }
    func YellowBlock() -> SCNNode {
        return buildBlock(color: YELLOW)
    }
    func BlueBlock() -> SCNNode {
        return buildBlock(color: BLUE)
    }
    func PurpleBlock() -> SCNNode {
        return buildBlock(color: PURPLE)
    }
    func GrayBlock() -> SCNNode {
        return buildBlock(color: GRAY)
    }
}


