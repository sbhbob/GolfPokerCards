//
//  NewGameView.swift
//  Toward Life
//
//  Created by Skyler Hope on 1/15/23.
//

import Foundation
import SwiftUI
//https://swiftwithmajid.com/2022/06/21/mastering-navigationstack-in-swiftui-deep-linking/
// from the newgame button on the contentview view


struct NewGameView: View {
    
    @State private var beginIsPresented = false
    @Environment(\.dismiss) var dismiss
    
    @State private var characterName = "Grunt"
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        VStack {
            Text("What is your name?")
                .opacity(25)
                .padding()
            
            Form {
                
                TextField(
                    "What is your name?",
                    text: $characterName
                )
            }
            .frame(height: 90)
            
            Text("\(characterName)'s Personal Grimore, entry #1")
            
            Text("\"Three cycles of the seasons have passed since mine induction into the arcane society of the Dying Rose, yet my advancement doth remain laborious and my fervor wanes. Methought a mastery of death would abate my thirst, yet a severe longing for the mysticism of LIFE doth tempt my soul. Verily, the path of enlightenment is clear.\"")
                .multilineTextAlignment(.center)
                .padding()
            
            Text("\"I must escape the Death Cult.\"")
            
            // nav link to begin game here
            
            // back dismiss, move forward fullscreenmodal
            Button("Begin")  {
                beginIsPresented.toggle()
                DispatchQueue.global().async {
                    let gameManager = GameManager()
                    let player = gameManager.createNewCharacter(name: characterName)
                    gameManager.currentPlayer = player
                    // Save the gameManager object in Core Data
                    let context = PersistenceController.shared.container.viewContext
                    let gameManagerData = GameManagerData(context: context)
                    gameManagerData.name = player.name
                    gameManagerData.experience = Int16(player.experience)
                    gameManagerData.spellList = player.spellList as NSObject
                    gameManagerData.activePerks = player.activePerks as NSObject
                    gameManagerData.fogOfWar = player.fogOfWar 
                    do {
                        try context.save()
                    } catch {
                        print("Failed saving")
                    }
                }
            }
            .fullScreenCover(isPresented: $beginIsPresented, content: MapView.init)
            
            .buttonStyle(.borderedProminent)
            .background(Color.gray)
            .padding()
            
            Spacer()
        }
        .navigationBarTitle("New Game")
        
    }
}

struct NewGameView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            NewGameView()
        }
    }
}
