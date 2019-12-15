//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Daniel Rybak on 16/10/2019.
//  Copyright © 2019 Daniel Rybak. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    
    var image: Image
    
    var body: some View {
        image
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia",
                                    "France",
                                    "Germany",
                                    "Ireland",
                                    "Italy",
                                    "Nigeria",
                                    "Poland",
                                    "Russia",
                                    "Spain",
                                    "UK",
                                    "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0 ... 2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var isAnimatedCorrect = false
    @State private var isAnimatedIncorrect = false
    @State private var incorrectAnswer = Int()
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .black]),
                startPoint: .top,
                endPoint: .bottom
            )
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 70) {
                
                Text("Tap the flag of: \(countries[correctAnswer])")
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        withAnimation(.interpolatingSpring(stiffness: 5, damping: 5)) {
                            self.flagTapped(number)
                            
                            switch number == self.correctAnswer {
                            case true:
                                self.isAnimatedCorrect = true
                                
                            case false:
                                self.incorrectAnswer = number
                                self.isAnimatedIncorrect = true
                            }
                        }
                    }) {
                        if number == self.correctAnswer {
                            FlagImage(image: Image(self.countries[number]))
                                .rotation3DEffect(.degrees(self.isAnimatedCorrect ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        } else if number == self.incorrectAnswer {
                            FlagImage(image: Image(self.countries[number]))
                                .modifier(Shake(animatableData: CGFloat(self.isAnimatedIncorrect ? 0 : 2)))
                        } else if number != self.correctAnswer {
                            FlagImage(image: Image(self.countries[number]))
                                .opacity(self.isAnimatedIncorrect ? 0.25 : 1)
                        }
                    }
                }
                
                VStack {
                    Text("Your current score is \(score)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
        .alert(isPresented: $showingScore ) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                })
        }
    }
    
    func flagTapped(_ number: Int) {
        let isCorrect = (number == correctAnswer)
        
        if isCorrect {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! this is the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
        isAnimatedIncorrect = false
        isAnimatedCorrect = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
