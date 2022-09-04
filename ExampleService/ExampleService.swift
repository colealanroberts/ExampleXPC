//
//  ExampleService.h
//  ExampleService
//
//  Created by Cole Roberts on 9/3/22.
//

import Foundation

@objc
final class ExampleService: NSObject, ExampleServiceProtocol {
    
    // MARK: - `Private Properties` -
    
    private let file = "example.txt"
    
    private var readSource: DispatchSourceRead!
    private var writeSource: DispatchSourceWrite!
    
    private var url: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(file)
    }
    
    // MARK: - `Init` -
    
    override init() {
        super.init()
        
        do {
            try "Hello, world".write(to: url, atomically: false, encoding: .utf8)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - `Public` -
    
    func write(_ string: String, _ completion: @escaping () -> Void) {
        let handle = try! FileHandle(forWritingTo: url)
        let source = DispatchSource.makeWriteSource(fileDescriptor: handle.fileDescriptor)
        
        guard let data = string.data(using: .utf8) else { fatalError() }
        
        do {
            try handle.seekToEnd()
            handle.write(data)
            completion()
        } catch {
            fatalError()
        }

        source.resume()
        self.writeSource = source
    }
    
    func observe(_ completion: @escaping (Data?) -> Void) {
        let handle = try! FileHandle(forReadingFrom: url)
        let source = DispatchSource.makeReadSource(fileDescriptor: handle.fileDescriptor)
        source.setEventHandler { [weak self] in
            self?.process(source: source, handle: handle, completion)
        }
        
        source.resume()
        self.readSource = source
    }
    
    private func process(source: DispatchSourceRead, handle: FileHandle, _ completion: @escaping(Data?) -> Void) {
        do {
            guard let data = try handle.readToEnd() else {
                return
            }
            
            completion(data)
        } catch {
            fatalError()
        }
    }
}
