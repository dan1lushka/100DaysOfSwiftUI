//
//  ContentView.swift
//  RockPaperSissors
//
//  Created by Daniel Rybak on 18/10/2019.
//  Copyright © 2019 Daniel Rybak. All rights reserved.
//

import SwiftUI

struct MoveImage: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .frame(width: 75, height: 75, alignment: .center)
            .foregroundColor(.black)
            .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
    }
}

struct ContentView: View {
    
    @State private var moveChosen = Int.random(in: 0 ... 2)
    @State private var score = 0
    @State private var roundsPlayed = 0
    @State private var gameOver = false
    var moves = ["Rock", "Paper", "Scissors"]
    var moveImages = ["icloud.fill", "doc", "scissors"]
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.black, .yellow]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 200) {
                VStack {
                    Text("You've played \(roundsPlayed / 10) games")
                    Text("You've played \(roundsPlayed % 10) rounds")
                    Text("Your score is \(score)")
                }
                
                VStack {
                    HStack(alignment: .bottom, spacing: 50) {
                        ForEach(0 ..< 3) { move in
                            Button(action: {
                                self.moveTapped(move: move)
                                self.checkIfGameOver()
                            }) {
                                VStack {
                                     MoveImage(image: Image(systemName: self.moveImages[move]))
                                    Text("\(self.moves[move])").foregroundColor(.black).font(.system(size: 25))
                                }

                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $gameOver) {
            Alert(title: Text("Well played!"), message: Text("your score is \(score) after 10 rounds"), dismissButton: .default(Text("Play again")))
        }
    }
    
    func moveTapped( move: Int) {
        if didWin(move) {
            score += 1
        } else {
            if score != 0 {
                score -= 1
            }
        }
        
        roundsPlayed += 1
    }
    
    func checkIfGameOver() {
        moveChosen = Int.random(in: 0 ... 2)
        
        if roundsPlayed % 10 == 0 {
            gameOver = true
        } else {
            gameOver = false
        }
    }
    
    func didWin(_ playerMove: Int) -> Bool {
        if playerMove == moveChosen {
            return false
        } else {
            if (playerMove == 0 && moveChosen == 1) || (playerMove == 1 && moveChosen == 2) || (playerMove == 2 && moveChosen == 0) {
                return false
            } else {
                return true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
