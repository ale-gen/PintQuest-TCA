//
//  PintQuest_TCAApp.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 29/04/2023.
//

import ComposableArchitecture
import SwiftUI

@main
struct PintQuest_TCAApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(store: .init(initialState: .init(),
                                  reducer: Home()))
        }
    }
}
