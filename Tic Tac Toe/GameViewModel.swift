//
//  GameViewModel.swift
//  Tic Tac Toe
//
//  Created by c94292a on 07/01/22.
//

import SwiftUI

final class GameViewModel : ObservableObject{
    
    //criando as colunas do grid separadamente
    let columns : [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Published var moves : [Move?] = Array(repeating: nil , count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem : AlertItem?

    func processPlayerMoves(for i:Int){
        if isSquaredOccupied(in: moves, forIndex: i){ return}
        moves[i]  = Move(player: Player.human, boardIndex: i)
        isGameBoardDisabled = true
        
        //check for win or draw condition for humans
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContext.humanWin
        }
        
        //check if there are no more squares clean
        if checkForDrawInMoves(in: moves) == true {
            alertItem = AlertContext.drawAlert
        }

        //computer move after 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let computerPosition = self.determineComputerMovePosition(in: self.moves)
            self.moves[computerPosition]  = Move(player: Player.computer, boardIndex: computerPosition)
            self.isGameBoardDisabled = false
            
            //check for win or draw condition for computer
            if self.checkWinCondition(for: .computer, in: self.moves){
                self.alertItem = AlertContext.computerWin
            }
            
            //check if there are no more squares clean
            if self.checkForDrawInMoves(in: self.moves) == true {
                self.alertItem = AlertContext.drawAlert
            }
        }
    }
    
    func resetGame(){
        moves = Array(repeating: nil , count: 9)
    }
    
    func isSquaredOccupied(in moves : [Move?], forIndex index: Int)->Bool{
        return moves.contains(where: { $0?.boardIndex == index} )
    }
    
    func determineComputerMovePosition(in moves:[Move?]) -> Int {
        let winPatterns : Set<Set<Int>> = [
            [0,1,2],
            [3,4,5],
            [6,7,8],
            [0,3,6],
            [1,4,7],
            [2,5,8],
            [0,4,8],
            [2,4,6]
        ]
        
        let computerMoves = moves.compactMap ({ $0 }).filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map {$0.boardIndex})
        
        //If AI can win, then win
        for pattern in winPatterns{
            let winPositionc = pattern.subtracting(computerPositions)
            if winPositionc.count == 1 {
                let isAvaible = !isSquaredOccupied(in: moves, forIndex: winPositionc.first!)
                if isAvaible{return winPositionc.first!}
            }
        }
        
        //If AI can not win, then block
        let humanMoves = moves.compactMap ({ $0 }).filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map {$0.boardIndex})
        
        //If AI can win, then win
        for pattern in winPatterns{
            let blockPosition = pattern.subtracting(humanPositions)
            if blockPosition.count == 1 {
                let isAvaible = !isSquaredOccupied(in: moves, forIndex: blockPosition.first!)
                if isAvaible{return blockPosition.first!}
            }
        }
        
        //If AI can not block, take the middle square
        let centerSquare = 4
        if !isSquaredOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        //If AI can not take the middle square, take random avaiable square
        var movePosition = Int.random(in: 0..<9)
        while isSquaredOccupied(in: moves, forIndex: movePosition){
             movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player : Player, in moves: [Move?])->Bool{
        let winPatterns : Set<Set<Int>> = [
            [0,1,2],
            [3,4,5],
            [6,7,8],
            [0,3,6],
            [1,4,7],
            [2,5,8],
            [0,4,8],
            [2,4,6]
        ]
        
        //all the moves without the nils for humans/computer moves
        let playerMoves = moves.compactMap ({ $0 })
            .filter { $0.player == player }
            
        //set of the indexes of the players moves
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        
        //verifies if the players indexes matches the winPatters, and if it does, returns true
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {return true}
        
        return false
    }
    
    func checkForDrawInMoves(in moves:[Move?])->Bool{
        return moves.compactMap{ $0 }.count == 9
    }
    
}
