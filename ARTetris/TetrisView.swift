//
//  TetrisView.swift
//  ARTetris
//
//  Created by Michael Tang on 12/23/17.
//  Copyright © 2017 Michael Tang. All rights reserved.
//

import Foundation
import SceneKit
import ARKit



class TetrisView {
    var well:[[SCNNode?]] = Array(repeatElement(Array(repeatElement(nil, count: COL)), count: ROW))
    var sceneView: ARSCNView
    var current: [SCNNode] = []
    var blockFactory:BlockFactory
    /*(x,y,z) are given as the origin of the plane*/
    var x:Float 
    var y:Float
    var z:Float
    
    init(sceneView: ARSCNView, origin:(Float,Float,Float)) {
        self.sceneView = sceneView
        self.blockFactory = BlockFactory()
        self.x = origin.0
        self.y = origin.1
        self.z = origin.2
    }
    /*draw() draw the SCNNode relative in position to the given plane*/
    func hard_draw(matrix m:[[Int]]) -> Void {
        while(self.current.count != 0){
            let b:SCNNode = self.current.popLast()!
            b.removeFromParentNode()
        }
        
        for i in 0..<ROW{
            for j in 0..<COL{
                /*Clean out last draw cycle*/
                if(self.well[i][j] != nil){
                    self.well[i][j]!.removeFromParentNode()
                    self.well[i][j] = nil
                }
                /*Build Node and give it a relative position if m[i][j] != 0*/
                if(m[i][j] != 0){
                    let b:SCNNode = self.translateIntToColor(int: m[i][j])
                    let location:SCNVector3 = SCNVector3(Float(j)*BOX_SIZE+self.x, Float(ROW-i)*BOX_SIZE+self.y, self.z)
                    b.position = location
                    
                    /*Save node to well*/
                    self.well[i][j] = b
                    
                    /*Display the node*/
                    self.sceneView.scene.rootNode.addChildNode(b)
                }
            }
        }
    }
    
    func draw(tetromino t:Tetromino) -> Void {
        
        while(self.current.count != 0){
            let b:SCNNode = self.current.popLast()!
            b.removeFromParentNode()
        }
        
        
        let height = t.height
        let width = t.width
        let top = t.top
        let left = t.left
        let m = t.matrix
    
        
        for i in 0..<height{
            for j in 0..<width{
                if(m[i][j] != 0){
                    let block:SCNNode = self.translateIntToColor(int: m[i][j])
                     //let location:SCNVector3 = SCNVector3(Float(j)*BOX_SIZE+self.x, Float(ROW-i)*BOX_SIZE+self.y, self.z)
                    let location:SCNVector3 = SCNVector3(BOX_SIZE*Float(j+left)+self.x, BOX_SIZE*Float(ROW-top-i)+self.y, self.z)
                    block.position = location
                    
                    self.sceneView.scene.rootNode.addChildNode(block)
                    self.current.append(block)
                }
            }
        }
    }
    
    func distroy() -> Void {
        self.sceneView.scene.physicsWorld.gravity = SCNVector3(0,-2,0)
        
        let table:SCNNode = SCNNode(geometry: SCNPlane(width: CGFloat(5), height: CGFloat(5)))
        table.position = SCNVector3(x: self.x, y: self.y, z: self.z)
        table.rotation = SCNVector4(x: 1, y: 0, z: 0, w: -Float.pi/2)
        table.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        table.geometry?.firstMaterial?.diffuse.contents = PLANE
        self.sceneView.scene.rootNode.addChildNode(table)

        
        for i in 0..<ROW{
            for j in 0..<COL{
                let x = -Float((Int(arc4random_uniform(6)) - 1) * i) * 0.01
                //let y = -Float((Int(arc4random_uniform(2)) - 1) * i) * 0.01
                let z = -Float((Int(arc4random_uniform(6)) - 1) * i) * 0.01
                
                let direction = SCNVector3Make(x, 0, z)
                let cell = well[i][j]
                if(cell != nil){
                    cell!.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
                    cell!.physicsBody!.angularDamping = 0.5
                    cell!.physicsBody!.applyForce(direction, asImpulse: true)
                }
            }
        }
    }
    
    func clearWellView() -> Void {
        let _ = self.current.map({ (node:SCNNode) -> SCNNode? in
            node.removeFromParentNode()
            return nil
        })
        for i in 0..<ROW{
            for j in 0..<COL{
                self.well[i][j]?.removeFromParentNode()
                self.well[i][j] = nil
            }
        }
    }
    
    private func translateIntToColor(int:Int) -> SCNNode {
        switch int {
        case 1:
            return self.blockFactory.RedBlock()
        case 2:
            return self.blockFactory.OrangeBlock()
        case 3:
            return self.blockFactory.YellowBlock()
        case 4:
            return self.blockFactory.BlueBlock()
        case 5:
            return self.blockFactory.PurpleBlock()
        case 6:
            return self.blockFactory.GrayBlock()
        case 7:
            return self.blockFactory.PinkBlock()
        default:
            return self.blockFactory.RedBlock()
        }
    }
    
    func draw_grid() -> Void {
        let sm = "float u = _surface.diffuseTexcoord.x; \n" +
            "float v = _surface.diffuseTexcoord.y; \n" +
            "int u100 = int(u * 100); \n" +
            "int v100 = int(v * 100); \n" +
            "if (u100 % 99 == 0 || v100 % 99 == 0) { \n" +
            "  // do nothing \n" +
            "} else { \n" +
            "    discard_fragment(); \n" +
        "} \n"
        
        let box = SCNNode(geometry: SCNBox(width: CGFloat(BOX_SIZE), height: CGFloat(BOX_SIZE), length: CGFloat(BOX_SIZE), chamferRadius: 0))
        for i in 0..<ROW{
            for j in 0..<COL{
            /*Build Node and give it a relative position if m[i][j] != 0*/
                
                let b = box.clone()
                b.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
                b.geometry?.firstMaterial?.shaderModifiers = [SCNShaderModifierEntryPoint.surface: sm]
                
                b.geometry?.firstMaterial?.isDoubleSided = true
                
                //let b:SCNNode = self.translateIntToColor(int: m[i][j])
                let location:SCNVector3 = SCNVector3(Float(j)*BOX_SIZE+self.x, Float(ROW-i)*BOX_SIZE+self.y, self.z)
                b.position = location
                
                /*Display the node*/
                self.sceneView.scene.rootNode.addChildNode(b)
            }
        }
    }
}
