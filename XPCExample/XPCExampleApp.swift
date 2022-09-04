//
//  XPCExampleApp.swift
//  XPCExample
//
//  Created by Cole Roberts on 9/3/22.
//

import SwiftUI
import ExampleService

@main
struct XPCExampleApp: App {
    
    private let service: ExampleServiceProtocol
    
    init() {
        let connection = NSXPCConnection(serviceName: "com.17degrees.ExampleService")
        connection.remoteObjectInterface = NSXPCInterface(with: ExampleServiceProtocol.self)
        
        connection.invalidationHandler = {
            print("Invalidated!")
        }
        
        connection.interruptionHandler = {
            print("Interruption")
        }
        
        connection.resume()
        
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            print(error.localizedDescription)
        } as! ExampleServiceProtocol
     
        service.observe { data in
            guard let data = data else { return }
            let str = String(data: data, encoding: .utf8)
            
            if str != "Hello, world" {
                fatalError(str!)
            }
        }
        
        self.service = service
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(service: service)
                .frame(width: 300, height: 200)
        }
    }
}
