//
//  Square.swift
//  Bombsweeper
//
//  Created by HPro2 on 10/13/21.
//

class Square{
    let row: Int
    let column: Int
    
    var isBomb = false
    var isFlagged = false
    var isShowing = false
    var adjBombs = 0
    
    init(row: Int, column: Int){
        self.row = row
        self.column = column
    }
}
