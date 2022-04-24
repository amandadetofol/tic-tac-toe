//
//  ContentView.swift
//  Tic Tac Toe


import SwiftUI


struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        GeometryReader {geometryReader in
            VStack{
                Text("Tic Tac Toe").font(.title2)
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) {i in
                        ZStack{
                            Circle()
                                .foregroundColor(.indigo)
                                .opacity(0.5)
                                .frame(width: geometryReader.size.width/3 - 15, height: geometryReader.size.width/3 - 15) //para deixar com tamanhos variaveis
                            Image(systemName: viewModel.moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }.onTapGesture {
                            viewModel.processPlayerMoves(for: i)
                        }
                    }
                }
                Spacer()
            }.padding()
                .disabled(viewModel.isGameBoardDisabled)
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: .default(alertItem.buttonTitle, action: {
                        viewModel.resetGame()
                    }))
                }
        }
    }
}

enum Player{
    case human
    case computer
}

struct Move {
    let player : Player
    let boardIndex : Int
    
    var indicator : String{
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
