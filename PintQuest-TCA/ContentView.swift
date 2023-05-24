//
//  ContentView.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 29/04/2023.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
