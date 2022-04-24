//
//  Alert.swift
//  Tic Tac Toe
//


import SwiftUI

struct AlertItem:Identifiable{
    let id = UUID()
    var title : Text
    var message : Text
    var buttonTitle : Text
}


struct AlertContext {
    static let humanWin = AlertItem(title: Text("You win!"),
                             message: Text("You are so smart"),
                             buttonTitle: Text("Hell yeah"))
    
    static let computerWin = AlertItem(title: Text("You lost!"),
                             message: Text("You are not that smart"),
                             buttonTitle: Text("Rematch"))
    
    static let drawAlert = AlertItem(title: Text("Draw"),
                             message: Text("What a battle of wits we have here..."),
                             buttonTitle: Text("Try again bro!"))
    
}
