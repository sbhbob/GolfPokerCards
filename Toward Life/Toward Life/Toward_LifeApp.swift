//
//  Toward_LifeApp.swift
//  Toward Life
//
//  Created by Skyler Hope on 1/10/23.
//

import SwiftUI

@main
struct Toward_LifeApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            LandingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            NewGame()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}


