//
//  ContentView.swift
//  PinchZoom
//
//  Created by Dodi Aditya on 27/04/23.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    
    // MARK: - FUNCTION
    
    // MARK: - CONTENT
    
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

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
