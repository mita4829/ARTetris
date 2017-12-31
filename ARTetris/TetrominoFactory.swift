//
//  TetrominoFactory.swift
//  ARTetris
//
//  Created by Michael Tang on 12/22/17.
//  Copyright © 2017 Michael Tang. All rights reserved.
//

/* Abstract Factory Design Pattern applied to the creation of tetrominoes aka tetris blocks */
import Foundation

//Constant flags for direction
let UP:Int = 1
let RIGHT:Int = 2
let DOWN:Int = 3
let LEFT:Int = 4


/* Tetromino must be polymorphic for this pattern to work */
class TetrominoFactory {
    var bag:[Int] = [0,1,2,3,4,5,6]
    //Return a random-concrete tetromino
    func newTetromino() -> Tetromino {
        let r:Int = self.selectFromBag()
        
        switch r {
        case 0:
            return O_Tetromino()
        case 1:
            return L_Tetromino()
        case 2:
            return J_Tetromino()
        case 3:
            return I_Tetromino()
        case 4:
            return S_Tetromino()
        case 5:
            return Z_Tetromino()
        case 6:
            return T_Tetromino()
        default:
            return I_Tetromino()
        }
    }
    func selectFromBag() -> Int {
        if(self.bag.count == 0){
            self.bag = [0,1,2,3,4,5,6]
        }
        
        let r_index:Int = Int(arc4random_uniform(UInt32(self.bag.count)))
        let item:Int = self.bag[r_index]
        self.bag.remove(at: r_index)
        return item
    }
    func O_Tetromino() -> Tetromino {
        return O()
    }
    func L_Tetromino() -> Tetromino {
        return L()
    }
    func J_Tetromino() -> Tetromino {
        return J()
    }
    func I_Tetromino() -> Tetromino {
        return I()
    }
    func S_Tetromino() -> Tetromino {
        return S()
    }
    func Z_Tetromino() -> Tetromino {
        return Z()
    }
    func T_Tetromino() -> Tetromino {
        return T()
    }
    init() {
        
    }
}


protocol Rotation {
    func rotate() -> Void
}

class Tetromino {
    var matrix:[[Int]]
    var height: Int = 0
    var width: Int = 0
    var orientation: Int = UP
    var top:Int = 0
    var left:Int = 0
    
    init(matrix m:[[Int]]) {
        self.matrix = m
    }
    
    func rotate() -> Void {
        print("Warning, rotate is being called from an abstracted class.")
    }
    func unRotate() -> Void {
        print("Warning, unRotated is being called from an abstracted class.")
    }
}

class O : Tetromino, Rotation {
    /*
     O matrix
     1 1
     1 1
     */
    init() {
        let O_Matrix = [[3,3],
                        [3,3]]
        super.init(matrix: O_Matrix)
        self.height = 2
        self.width = 2
        
    }
    /* rotate() rotates the matrix 90 degrees clockwise */
    override func rotate() -> Void{
        /* Change the matrix depending on the tetromino's current orientation */
        if(self.orientation == UP){
            self.orientation = RIGHT
        }else if(self.orientation == RIGHT){
            self.orientation = DOWN
        }else if(self.orientation == DOWN){
            self.orientation = LEFT
        }else if(self.orientation == LEFT){
            self.orientation = UP
        }
    }
    override func unRotate() -> Void {
        if(self.orientation == UP){
            self.orientation = LEFT
        }else if(self.orientation == RIGHT){
            self.orientation = UP
        }else if(self.orientation == DOWN){
            self.orientation = RIGHT
        }else if(self.orientation == LEFT){
            self.orientation = DOWN
        }
    }
}

class L : Tetromino, Rotation {
    /*
     L Matrix
     1 0
     1 0
     1 1
     */
    init(){
        let L_Matrix = [[2,0],
                        [2,0],
                        [2,2]]
        super.init(matrix: L_Matrix)
        self.height = 3
        self.width = 2
    }
    /* rotate() rotates the matrix 90 degrees clockwise */
    override func rotate() -> Void{
        /* Change the matrix depending on the tetromino's current orientation */
        if(self.orientation == UP){
            self.orientation = RIGHT
            self.height = 2
            self.width = 3
            self.matrix = [[2,2,2],
                           [2,0,0]]
        }else if(self.orientation == RIGHT){
            self.orientation = DOWN
            self.height = 3
            self.width = 2
            self.matrix = [[2,2],
                           [0,2],
                           [0,2]]
        }else if(self.orientation == DOWN){
            self.orientation = LEFT
            self.height = 2
            self.width = 3
            self.matrix = [[0,0,2],
                           [2,2,2]]
        }else if(self.orientation == LEFT){
            self.orientation = UP
            self.height = 3
            self.width = 2
            self.matrix = [[2,0],
                           [2,0],
                           [2,2]]
        }
    }
    override func unRotate() -> Void {
        if(self.orientation == UP){
            self.orientation = DOWN
            self.rotate()
        }else if(self.orientation == RIGHT){
            self.orientation = LEFT
            self.rotate()
        }else if(self.orientation == DOWN){
            self.orientation = UP
            self.rotate()
        }else if(self.orientation == LEFT){
            self.orientation = RIGHT
            self.rotate()
        }
    }
}

class J : Tetromino, Rotation {
    /*
     J Matrix
     0 1
     0 1
     1 1
     */
    init(){
        let J_Matrix = [[0,4],
                        [0,4],
                        [4,4]]
        super.init(matrix: J_Matrix)
        self.height = 3
        self.width = 2
    }
    /* rotate() rotates the matrix 90 degrees clockwise */
    override func rotate() -> Void{
        /* Change the matrix depending on the tetromino's current orientation */
        if(self.orientation == UP){
            self.orientation = RIGHT
            self.height = 2
            self.width = 3
            self.matrix = [[4,0,0],
                           [4,4,4]]
        }else if(self.orientation == RIGHT){
            self.orientation = DOWN
            self.height = 3
            self.width = 2
            self.matrix = [[4,4],
                           [4,0],
                           [4,0]]
        }else if(self.orientation == DOWN){
            self.orientation = LEFT
            self.height = 2
            self.width = 3
            self.matrix = [[4,4,4],
                           [0,0,4]]
        }else if(self.orientation == LEFT){
            self.orientation = UP
            self.height = 3
            self.width = 2
            self.matrix = [[0,4],
                           [0,4],
                           [4,4]]
        }
    }
    override func unRotate() -> Void {
        if(self.orientation == UP){
            self.orientation = DOWN
            self.rotate()
        }else if(self.orientation == RIGHT){
            self.orientation = LEFT
            self.rotate()
        }else if(self.orientation == DOWN){
            self.orientation = UP
            self.rotate()
        }else if(self.orientation == LEFT){
            self.orientation = RIGHT
            self.rotate()
        }
    }
}

class I : Tetromino, Rotation {
    /*
     I Matrix
     1
     1
     1
     1
     */
    init(){
        let I_Matrix = [[5,5,5,5]]
        super.init(matrix: I_Matrix)
        self.height = 1
        self.width = 4
    }
    /* rotate() rotates the matrix 90 degrees clockwise */
    override func rotate() -> Void{
        /* Change the matrix depending on the tetromino's current orientation */
        if(self.orientation == UP){
            self.orientation = RIGHT
            self.height = 4
            self.width = 1
            self.matrix = [[5],
                           [5],
                           [5],
                           [5]]
        }else if(self.orientation == RIGHT){
            self.orientation = DOWN
            self.height = 1
            self.width = 4
            self.matrix = [[5,5,5,5]]
        }else if(self.orientation == DOWN){
            self.orientation = LEFT
            self.height = 4
            self.width = 1
            self.matrix = [[5],
                           [5],
                           [5],
                           [5]]
        }else if(self.orientation == LEFT){
            self.orientation = UP
            self.height = 1
            self.width = 4
            self.matrix = [[5,5,5,5]]
        }
    }
    override func unRotate() -> Void {
        if(self.orientation == UP){
            self.orientation = DOWN
            self.rotate()
        }else if(self.orientation == RIGHT){
            self.orientation = LEFT
            self.rotate()
        }else if(self.orientation == DOWN){
            self.orientation = UP
            self.rotate()
        }else if(self.orientation == LEFT){
            self.orientation = RIGHT
            self.rotate()
        }
    }
}

class S : Tetromino, Rotation {
    /*
     S matrix
     0 1 1
     1 1 0
     */
    init() {
        let S_Matrix = [[0,7,7],
                        [7,7,0]]
        super.init(matrix: S_Matrix)
        self.height = 2
        self.width = 3
    }
    /* rotate() rotates the matrix 90 degrees clockwise */
    override func rotate() -> Void{
        /* Change the matrix depending on the tetromino's current orientation */
        if(self.orientation == UP){
            self.orientation = RIGHT
            self.height = 3
            self.width = 2
            self.matrix = [[7,0],
                           [7,7],
                           [0,7]]
        }else if(self.orientation == RIGHT){
            self.orientation = DOWN
            self.height = 2
            self.width = 3
            self.matrix = [[0,7,7],
                           [7,7,0]]
        }else if(self.orientation == DOWN){
            self.orientation = LEFT
            self.height = 3
            self.width = 2
            self.matrix = [[7,0],
                           [7,7],
                           [0,7]]
        }else if(self.orientation == LEFT){
            self.orientation = UP
            self.height = 2
            self.width = 3
            self.matrix = [[0,7,7],
                           [7,7,0]]
        }
    }
    override func unRotate() -> Void {
        if(self.orientation == UP){
            self.orientation = DOWN
            self.rotate()
        }else if(self.orientation == RIGHT){
            self.orientation = LEFT
            self.rotate()
        }else if(self.orientation == DOWN){
            self.orientation = UP
            self.rotate()
        }else if(self.orientation == LEFT){
            self.orientation = RIGHT
            self.rotate()
        }
    }
}

class Z : Tetromino, Rotation {
    /*
     Z matrix
     1 1 0
     0 1 1
     */
    init() {
        let Z_Matrix = [[6,6,0],
                        [0,6,6]]
        super.init(matrix: Z_Matrix)
        self.height = 2
        self.width = 3
    }
    /* rotate() rotates the matrix 90 degrees clockwise */
    override func rotate() -> Void{
        /* Change the matrix depending on the tetromino's current orientation */
        if(self.orientation == UP){
            self.orientation = RIGHT
            self.height = 3
            self.width = 2
            self.matrix = [[0,6],
                           [6,6],
                           [6,0]]
        }else if(self.orientation == RIGHT){
            self.orientation = DOWN
            self.height = 2
            self.width = 3
            self.matrix = [[6,6,0],
                           [0,6,6]]
        }else if(self.orientation == DOWN){
            self.orientation = LEFT
            self.height = 3
            self.width = 2
            self.matrix = [[0,6],
                           [6,6],
                           [6,0]]
        }else if(self.orientation == LEFT){
            self.orientation = UP
            self.height = 2
            self.width = 3
            self.matrix = [[6,6,0],
                           [0,6,6]]
        }
    }
    override func unRotate() -> Void {
        if(self.orientation == UP){
            self.orientation = DOWN
            self.rotate()
        }else if(self.orientation == RIGHT){
            self.orientation = LEFT
            self.rotate()
        }else if(self.orientation == DOWN){
            self.orientation = UP
            self.rotate()
        }else if(self.orientation == LEFT){
            self.orientation = RIGHT
            self.rotate()
        }
    }
}

class T : Tetromino, Rotation {
    /*
     T matrix
     1 1 1
     0 1 0
     */
    init() {
        let T_Matrix = [[1,1,1],
                        [0,1,0]]
        super.init(matrix: T_Matrix)
        self.height = 2
        self.width = 3
    }
    /* rotate() rotates the matrix 90 degrees clockwise */
    override func rotate() -> Void{
        /* Change the matrix depending on the tetromino's current orientation */
        if(self.orientation == UP){
            self.orientation = RIGHT
            self.height = 3
            self.width = 2
            self.matrix = [[0,1],
                           [1,1],
                           [0,1]]
        }else if(self.orientation == RIGHT){
            self.orientation = DOWN
            self.height = 2
            self.width = 3
            self.matrix = [[0,1,0],
                           [1,1,1]]
        }else if(self.orientation == DOWN){
            self.orientation = LEFT
            self.height = 3
            self.width = 2
            self.matrix = [[1,0],
                           [1,1],
                           [1,0]]
        }else if(self.orientation == LEFT){
            self.orientation = UP
            self.height = 2
            self.width = 3
            self.matrix = [[1,1,1],
                           [0,1,0]]
        }
    }
    override func unRotate() -> Void {
        if(self.orientation == UP){
            self.orientation = DOWN
            self.rotate()
        }else if(self.orientation == RIGHT){
            self.orientation = LEFT
            self.rotate()
        }else if(self.orientation == DOWN){
            self.orientation = UP
            self.rotate()
        }else if(self.orientation == LEFT){
            self.orientation = RIGHT
            self.rotate()
        }
    }
}

