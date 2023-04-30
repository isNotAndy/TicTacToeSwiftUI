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

    var body: some View {
        VStack {
            Text(winner == nil ? "\(player)'s turn" : "\(winner!.winner) wins!")
                .font(.title)
                .padding()

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
        .alert(item: $winner) { winner in
            Alert(title: Text("\(winner.winner) wins!"), message: Text("Congratulations!"), dismissButton: .default(Text("Play again")) {
                resetBoard()
            })
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                resetBoard()
            }
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
