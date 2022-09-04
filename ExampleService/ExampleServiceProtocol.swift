//
//  ExampleServiceProtocol.swift
//  ExampleService
//
//  Created by Cole Roberts on 9/3/22.
//

import Foundation

@objc public protocol ExampleServiceProtocol {
    func observe(_ completion: @escaping(Data?) -> Void)
    func write(_ string: String, _ completion: @escaping() -> Void)
}
