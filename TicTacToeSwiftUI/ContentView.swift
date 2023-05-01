//
//  ContentView.swift
//  TicTacToeSwiftUI
//
//  Created by Андрей Барсуков on 29.04.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var board = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State private var player = "X"
    @State private var winner: Winner? = nil
    
    // UserDef
    @State private var wins = UserDefaults.standard.integer(forKey: "wins")
    @State private var losses = UserDefaults.standard.integer(forKey: "losses")
    
    var body: some View {
        VStack {
            Text(winner?.winner != nil ? "\(winner!.winner) wins!" : "\(player)'s turn")
                .font(.title)
                .padding()
            
            Text("X score: \(wins)")
            Text("O score: \(losses)")
            
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { col in
                        Button(action: {
                            if board[row][col].isEmpty && winner == nil {
                                board[row][col] = player
                                checkWinner()
                                player = player == "X" ? "O" : "X"
                            }
                        }) {
                            Text(board[row][col])
                                .font(.system(size: 80))
                                .frame(width: 100, height: 100)
                                .background(Color.white)
                                .foregroundColor(Color.black)
                                .border(Color.black, width: 1)
                        }
                    }
                }
            }
        }
    }
    
    func checkWinner() {
        for i in 0..<3 {
            if board[i][0] == board[i][1] && board[i][1] == board[i][2] && !board[i][0].isEmpty {
                winner = Winner(winner: board[i][0])
            }
            if board[0][i] == board[1][i] && board[1][i] == board[2][i] && !board[0][i].isEmpty {
                winner = Winner(winner: board[0][i])
            }
        }
        if board[0][0] == board[1][1] && board[1][1] == board[2][2] && !board[0][0].isEmpty {
            winner = Winner(winner: board[0][0])
        }
        if board[0][2] == board[1][1] && board[1][1] == board[2][0] && !board[0][2].isEmpty {
            winner = Winner(winner: board[0][2])
        }
        if winner == nil && board.flatMap({ $0 }).filter({ $0.isEmpty }).count == 0 {
            winner = Winner(winner: "Nobody")
        }
        
        if let winner = winner?.winner {
            if winner == "X" {
                wins += 1
                UserDefaults.standard.set(wins, forKey: "wins")
            } else if winner == "O" {
                losses += 1
                UserDefaults.standard.set(losses, forKey: "losses")
            }
        }
        
        if winner != nil {
            resetBoard()
        }
    }
    
    
    //  Очищает игровое поле
    func resetBoard() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        player = "X"
        winner = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Winner: Identifiable {
    let id = UUID()
    let winner: String
}
