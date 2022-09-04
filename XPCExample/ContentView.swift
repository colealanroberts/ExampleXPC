//
//  ContentView.swift
//  XPCExample
//
//  Created by Cole Roberts on 9/3/22.
//

import SwiftUI
import ExampleService

struct ContentView: View {
    
    let service: ExampleServiceProtocol
    
    // MARK: - `Properties` -
    
    @State var text: String = ""
    
    var body: some View {
        VStack {
            Text("An example XPC app")
                .padding()
            TextField(
                "Enter text to write to a file...",
                text: $text
            ).padding()
            
            Button("Write to file") {
                service.write(text) {}
            }
        }
    }
}
