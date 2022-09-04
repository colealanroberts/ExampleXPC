//
//  main.swift
//  ExampleService
//
//  Created by Cole Roberts on 9/3/22.
//

import Foundation

final class ServiceDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: ExampleServiceProtocol.self)
        let service = ExampleService()
        newConnection.exportedObject = service
        newConnection.resume()
        
        return true
    }
}

let delegate = ServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
