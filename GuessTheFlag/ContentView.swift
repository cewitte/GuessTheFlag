//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Carlos Eduardo Witte on 05/07/24.
//

import SwiftUI

//Go back to the Guess the Flag project and add some animation:
//
// When you tap a flag, make it spin around 360 degrees on the Y axis.
// Make the other two buttons fade out to 25% opacity.
// Add a third effect of your choosing to the two flags the user didn’t choose – maybe make them scale down? Or flip in a different direction? Experiment!



struct SpinAroundModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: SpinAroundModifier(amount: 360, anchor: .center),
            identity: SpinAroundModifier(amount: -360, anchor: .center)
        )
    }
}

struct FlagImage: View {
    var country: String
    
    var body: some View {
            Image(country)
                .clipShape(.capsule)
                .shadow(radius: 5)
                .transition(.pivot)
    }
}

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
        .shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    // resolving the challenge
    @State private var score: Int = 0
    @State private var maxPlays = 2
    @State private var playCount: Int = 0
    
    @State private var shouldSpin = false

        
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .blue, location: 0.3),
                .init(color: .red, location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing:15){
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            // flag was tapped
//                            flagTapped(number)
                            if playCount >= maxPlays {
                                scoreTitle = "Game Over"
                                playCount = 0
                            } else if number == correctAnswer {
                                scoreTitle = "Correct"
                                score += 5
                            } else {
                                scoreTitle = "Wrong!"
                                score -= 5
                            }
                            
                            scoreTitle += " That's the flag of \(countries[number])"
                            playCount += 1
                            showingScore = true
                            shouldSpin.toggle()
                        } label: {
                            if shouldSpin {
                                FlagImage(country: countries[number])
                            } else {
                                FlagImage(country: countries[number])
                            }
                        }
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                
                Spacer()
                Spacer()
                
                Text("\(playCount >= maxPlays ? "Final Score" : "Score"): \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text("Attempts: \(playCount)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("\(playCount >= maxPlays ? "Start Over" : "Continue")", action: askQuestion)
        } message: {
            Text("Your \(playCount >= maxPlays ? "final" : String()) score is \(score)")
        }
        
    }
    
    func askQuestion() {
        if playCount >= maxPlays {
            playCount = 0
            score = 0
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
