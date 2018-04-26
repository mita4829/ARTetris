//
//  TetrisModel.swift
//  ARTetris
//
//  Created by Michael Tang on 12/23/17.
//  Copyright © 2017 Michael Tang. All rights reserved.
//

import Foundation
import UIKit

let ROW: Int = 16
let COL: Int = 8

let M_DOWN:Int = 1
let M_LEFT:Int = 2
let M_RIGHT:Int = 3

/*TIME_DELTA is the speed at which the tetrominoes fall in seconds.
 0.6: Slow
 0.5: Average
 0.4: Hard
 0.3: Impossible to win...
 */
var TIME_DELTA:Double = 0.5

class TetrisModel {
    var wellModel:[[Int]] = Array(repeatElement(Array(repeatElement(0, count: COL)), count: ROW))
    
    var factory:TetrominoFactory
    var current:Tetromino? = nil
    var direction:Int = M_DOWN
    var didRotation:Bool = false
    /*controller and view needs to be weak to avoid a strong retention cycle*/
    var view:TetrisView!
    var controller:UIViewController!
    /*lock is used to syncronize threads that touches/mutates the direction variable. Super painful to debug when threads conflict*/
    var lock:NSLock = NSLock()

    var timer:Timer!
    var score:Int = 0
    
    
    init(view v:TetrisView, controller c:UIViewController) {
        self.view = v
        self.controller = c
        self.factory = TetrominoFactory()
    }
    
    func startGame() -> Void {
        if(self.timer != nil){
            return
        }
        self.view.draw_grid()
        /*The magic happens here?*/
        var sec:Int = 0
        timer = Timer.scheduledTimer(withTimeInterval:TIME_DELTA, repeats: true){ _ in
            //If the current moving tetromino is nil, get a new one from the factory
            print(sec)
            if(self.current == nil){
                self.current = self.factory.newTetromino()
                self.current!.left = Int(COL/2)-1
                self.current!.top = 0
            }
            /* Acquire the lock to start the projection validation */
            self.lock.lock()
            
            //Project it
            if(self.didRotation == true){
                self.current!.rotate()
            }
            let result:Int = self.project(tetromino: self.current!, inDirection: self.direction)

            if(result == 0 || result == 1 || result == 4){
                if(self.direction == M_RIGHT){
                    self.current!.left += 1
                }else if(self.direction == M_LEFT){
                    self.current!.left -= 1
                }
                if(result == 1 || result == 4){
                    self.hard_union(tetromino: self.current!)
                    self.current = nil
                }
            }else if(result == 2 || result == 7){
                if(self.didRotation == true){
                    self.current!.unRotate()
                }
                if(self.direction == M_RIGHT){
                    self.current!.left -= 1
                }else if(self.direction == M_LEFT){
                    self.current!.left += 1
                }
                self.current!.top -= 1
            }else if(result == 5 || result == 6){
                if(self.didRotation == true){
                    self.current!.unRotate()
                }
                self.current!.top -= 1
            }
            else if(result == 3){
                /*If the game is over, the lock needs to be released here, or else deadlock will happen on the next game*/
                self.lock.unlock()
                self.view.distroy()
                self.endGame()
                return
            }
            
            /*Detect a if lines can be cleared*/
            let clearableLine:[Int] = self.canLinesBeCleared()
            
            /*Move the tetromino down one. If a rotation happened, don't skip one down increment*/
            if(self.current != nil){
                //let _:[[Int]] = self.union(tetromino: self.current!)
                self.view.draw(tetromino: self.current!)
                if(result != 7){
                    self.current!.top += 1
                }
            }else{
                if(clearableLine.count > 0){
                    self.clear(lines: clearableLine)
                    self.score += 10*clearableLine.count
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                }
                self.view.hard_draw(matrix: self.wellModel)
            }
            
            //Move it down and reset didRotate
            self.didRotation = false
            self.direction = M_DOWN
            
            /*deinit tetromino*/
            //self.current = nil
            /*Release lock*/
            self.lock.unlock()
            
            sec += 1
        }
    }
    
    func endGame() -> Void {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        let button = UIButton(frame: CGRect(x: 0, y: -80, width: UIScreen.main.bounds.width, height: 80))
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.addTarget(self, action: #selector(TetrisModel.playAgain), for: UIControlEvents.touchUpInside)
        button.tag = 1
        button.setTitle("Final score: \(self.score). Play Again?", for: UIControlState.normal)
        self.controller!.view.addSubview(button)
        UIView.animate(withDuration: 0.5, animations: {
            button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
        })
        self.score = 0
    }
    
    @objc func playAgain() -> Void {
        UIView.animate(withDuration: 0.5, animations: {
            self.controller!.view.viewWithTag(1)?.frame = CGRect(x: 0, y: -80, width: UIScreen.main.bounds.width, height: 80)
        })
        self.controller!.view.viewWithTag(1)?.removeFromSuperview()
        self.view.clearWellView()
        self.clearWellModel()
        self.current = nil
        self.startGame()
    }
    
    func rotate() -> Void {
        self.lock.lock()
        if(self.current != nil){
            self.didRotation = true
        }
        self.lock.unlock()
    }
    
    func swipe(sender: UISwipeGestureRecognizer) -> Void {
        self.lock.lock()
        if(self.current != nil){
            if(sender.direction == .right){
                self.direction = M_RIGHT
            }else if(sender.direction == .left){
                self.direction = M_LEFT
            }else if(sender.direction == .down){
                self.direction = M_DOWN
            }
        }
        self.lock.unlock()
    }
    /*
     Projection ID
     
     This function projects a sub-matrix that represents a tetromino's form onto the superset well's matrix and calculates the legality of the current state and also check the desired moving direction to see if it's also legal.
     
     0:Successful - Continue S
     1:Tetromino touched floor S
     2:Tetromino is being mapped out of bounds F
     3:Collision with current projection on top row F
     4:Tetromino connected with existing tetromino and cannot go further down S
     5:Tetromino cannot move right F
     6:Tetromino cannot move left F
     7:Collision potential rotation
     */
    func project(tetromino t:Tetromino, inDirection d:Int) -> Int {
        let m:[[Int]] = t.matrix
        let matrixWidth:Int = t.width
        let matrixHeight:Int = t.height
        let top:Int = t.top >= 0 ? t.top : 0
        let left:Int = t.left >= 0 ? t.left : 0
        
        /*Tetromino out of bounds*/
        if((matrixWidth + left > COL || left < 0) || (top+matrixHeight > ROW)){
            /*Cannot update view, return failure*/
            //print("Boundary error")
            return 2
        }
        
        /*Detect if current projection overlaps existing tetrominoes on the top row. If so, gameover*/
        if(self.wellModel[0][Int(COL/2)-1] != 0 || self.wellModel[0][Int(COL/2)] != 0 || self.wellModel[1][Int(COL/2)-1] != 0 || self.wellModel[1][Int(COL/2)] != 0){
            return 3
        }
        
        /*Check for collision conflict*/
        for i in top..<top+matrixHeight{
            for j in left..<left+matrixWidth{
                if(i<ROW && j<COL && m[i-top][j-left] != 0 && self.wellModel[i][j] != 0){
                    //print("Collision conflict")
                    return 7
                }
            }
        }
        
        
        if(d == M_RIGHT){
            if(left+matrixWidth+1 > COL){
                //print("Cannot right shift due to no more space")
                return 5
            }
            for i in top..<top+matrixHeight{
                for j in left..<left+matrixWidth{
                    if(j+1<COL && m[i-top][j-left] != 0 && self.wellModel[i][j+1] != 0){
                        print("Cannot right shift due to conflict")
                        return 5
                    }
                }
            }
        }else if(d == M_LEFT){
            if(left-1 < 0){
                //print("Cannot left shift due to no more space")
                return 6
            }
            for i in top..<top+matrixHeight{
                for j in left..<left+matrixWidth{
                    if(j-1>=0 && m[i-top][j-left] != 0 && self.wellModel[i][j-1] != 0){
                        //print("Cannot left shift due to conflict")
                        return 6
                    }
                }
            }
        }
        /*Check for pending direction and its validity*/
        else if(d == M_DOWN && top+matrixHeight<ROW){
            /*Check one row below current-projected tetromino and scan for filled areas
             x x :0
             0 x :1
             1 1 :2
             tetromino x will scan row 2 and find column-pairs of size two [x,1] and [0,1]. [x,1] indicates a block, and tetromino x can't go further down
             */
            for i in top..<top+matrixHeight{
                for j in left..<left+matrixWidth{
                    if(i+1<ROW && m[i-top][j-left] != 0 && self.wellModel[i+1][j] != 0){
                        /*Update view. Tetromino cannot go further down*/
                        //print("Tetromino fitted onto another")
                        return 4
                    }
                }
            }
        }
        
        /*Check if tetromino touches the floor*/
        if(matrixHeight + top == ROW){
            /*Communicate to view to update tetromino*/
            //print("Tetromino touched the ground accept")
            return 1
        }
        
        //print("Pass")
        return 0
    }
    
    private func clearWellModel() -> Void {
        for i in 0..<ROW{
            for j in 0..<COL{
                self.wellModel[i][j] = 0
            }
        }
    }
    
    /*union takes the union of the current tetromino's matrix with the well and returns a copy of the result without mutating the originals*/
    private func union(tetromino t:Tetromino) -> [[Int]] {
        let m:[[Int]] = t.matrix
        var copy:[[Int]] = Array(repeatElement(Array(repeatElement(0, count: COL)), count: ROW))
        /* Copy well to copy */
        for i in 0..<ROW{
            for j in 0..<COL{
                copy[i][j] = self.wellModel[i][j]
            }
        }
        
        t.top = t.top < 0 ?  0 : t.top
        t.top = t.top >= ROW ? ROW-1 : t.top
        t.left = t.left < 0 ? 0 : t.left
        t.left = t.left >= COL ? COL-1 : t.left
        
        /* Copy m to copy */
        for i in t.top..<t.height+t.top{
            for j in t.left..<t.width+t.left{
                copy[i][j] = m[i-t.top][j-t.left] != 0 ? m[i-t.top][j-t.left] : copy[i][j]
            }
        }
        //printWell(well:copy)
        return copy
    }
    
    /*Same thing as union but actually modify wellModel*/
    private func hard_union(tetromino t:Tetromino) -> Void {
        let m:[[Int]] = t.matrix
        /* Copy m to copy */
        for i in t.top..<t.height+t.top{
            for j in t.left..<t.width+t.left{
                self.wellModel[i][j] = m[i-t.top][j-t.left] != 0 ? m[i-t.top][j-t.left] : self.wellModel[i][j]
            }
        }
        //printWell(well:self.wellModel)
        return
    }
    
    private func canLinesBeCleared() -> [Int] {
        /*Work here for clearing out lines*/
        var linesToBeCleared:[Int] = []
        for i in (0..<ROW).reversed(){
            var accept:Bool = true
            for j in 0..<COL{
                if(self.wellModel[i][j] == 0){
                    accept = false
                    break
                }
            }
            if(accept){
                linesToBeCleared.append(i)
            }
        }
        return linesToBeCleared
    }
    
    private func clear(lines l:[Int]) -> Void {
        self.wellModel.removeSubrange(l.last!..<l[0]+1)
        for _ in 0..<l.count{
            self.wellModel.insert(Array(repeatElement(0, count: COL)), at: 0)
        }
    }
    
    private func printWell(well w:[[Int]]) -> Void {
        for i in 0..<ROW{
            for j in 0..<COL{
                print(String(w[i][j])+" ", terminator:"")
            }
            print()
        }
    }
}
