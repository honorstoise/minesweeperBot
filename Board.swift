//
//  Board.swift
//  Bombsweeper
//
//  Created by HPro2 on 10/13/21.
//

import Foundation

class Board{
    let size: Int
    var squares:[[Square]] = []
    var bombs: Int = 0
    
    init(size:Int){
        self.size = size
        for row in 0..<size{
            var squareRow: [Square] = []
            for column in 0..<size{
                let square = Square(row: row, column: column)
                squareRow.append(square)
            }
            squares.append(squareRow)
        }
    }
    
    func resetBoard(){
        bombs = 0
        for row in 0..<size{
            for column in 0..<size{
                squares[row][column].isShowing = false
                squares[row][column].isBomb = false
                squares[row][column].isFlagged = false
                
                placeBomb(square: squares[row][column])
            }
        }
        for row in 0..<size{
            for column in 0..<size{
                countBombs(square: squares[row][column])
            }
        }
    }
    
    func placeBomb(square: Square){
        square.isBomb = Int.random(in: 1...10) == 1
        if square.isBomb{
            bombs += 1
        }
    }
    
    func countBombs(square: Square){
        let neighbors = getNeighbors(square: square)
        var bombs = 0
        
        for neighbor in neighbors{
            if neighbor.isBomb{
                bombs += 1
            }
        }
        
        square.adjBombs = bombs
    }
    
    func countFilledSquares(square: Square) -> Int{
        let neighbors = getNeighbors(square: square)
        var filledSquares = 0
        
        for neighbor in neighbors{
            if !neighbor.isShowing{
                filledSquares += 1
            }
        }
        return filledSquares
    }
    
    func getNeighbors(square: Square) -> [Square]{
        var connectedSquares: [Square] = []
        let offsets = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 0), (0, 1), (1, -1), (1, 0), (1, 1)]
        for (rowOffset, columnOffset) in offsets{
            let potentialSquare: Square? = isSquareThere(row: square.row + rowOffset, column: square.column + columnOffset)
            if let realSquare = potentialSquare{
                connectedSquares.append(realSquare)
            }
        }
        return connectedSquares
    }
    
    func getFilledNeighbors(square:Square) -> [Square]{
        var connectedSquares: [Square] = []
        let offsets = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 0), (0, 1), (1, -1), (1, 0), (1, 1)]
        for (rowOffset, columnOffset) in offsets{
            let potentialSquare: Square? = isSquareFilled(row: square.row + rowOffset, column: square.column + columnOffset)
            if let realSquare = potentialSquare{
                connectedSquares.append(realSquare)
            }
        }
        return connectedSquares
    }
    
    func isSquareThere(row: Int, column: Int) -> Square?{
        if row >= 0 && row < size && column >= 0 && column < size{
            return squares[row][column]
        }else{
            return nil
        }
    }
    
    func isSquareFilled(row: Int, column: Int) -> Square?{
        if (row >= 0 && row < size && column >= 0 && column < size) && !(squares[row][column].isShowing){
            return squares[row][column]
        }else{
            return nil
        }
    }
}
