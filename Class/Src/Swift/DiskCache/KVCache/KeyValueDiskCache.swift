//
//  KeyValueDiskCache.swift
//  SwiftLvDB
//
//  Created by Dcell on 2018/7/11.
//

import UIKit


/// KeyValue 对象实现磁盘存储的协议
final class KeyValueDiskCache: NSObject {
    private var leveldb:LevelDBBridge?
    private var mutex:pthread_mutex_t
    private let diskPath:String

    required init(path: String) {
        self.diskPath = path
        self.leveldb = LevelDBBridge(path: path)
        self.mutex = pthread_mutex_t()
        pthread_mutex_init(&self.mutex,nil)
    }
}

extension KeyValueDiskCache:DiskCacheProtocol{
    
    func object(forKey defaultName: String) -> Any?{
        if let data = self.data(forKey: defaultName){
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        }
        return nil
    }
    func object<T>(_ type:T.Type,forKey defaultName: String) -> T? where T : Decodable {
        guard let date = self.data(forKey: defaultName) else{
            return nil
        }
        let jsonDecode = JSONDecoder()
        if let codeableObject = try? jsonDecode.decode(type, from: date){
           return codeableObject
        }
        return nil
    }
    
    func set<T:Codable>(_ value:T,forKey defaultName: String) throws{
        let jsonencode =  JSONEncoder()
        jsonencode.outputFormatting = .prettyPrinted
        let data = try jsonencode.encode(value)
        self.set(data, forKey: defaultName)
    }
    
    //TODO
    func removeObject(forKey defaultName: String) {
        
    }
    
    func string(forKey defaultName: String) -> String? {
        if let data = self.data(forKey: defaultName){
            return String(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }
    
    func array(forKey defaultName: String) -> [Any]? {
        var array:[Any]? = nil
         pthread_mutex_lock(&self.mutex)
        let diskUrl = URL(fileURLWithPath: self.diskPath)
        let subDiskUrl = diskUrl.appendingPathComponent(defaultName, isDirectory: true)
        do {
            guard let leveldb = LevelDBBridge(path: subDiskUrl.path) else{
                throw NSError()
            }
            array =  leveldb.allObjectValues { (data) -> Any? in
                return NSKeyedUnarchiver.unarchiveObject(with: data)
            }
            
        } catch {
            SwiftLvDB.printLog(log: "\(error)")
        }
        pthread_mutex_unlock(&self.mutex)
        return array
    }
    
    func dictionary(forKey defaultName: String) -> [String : Any]? {
        var dic:[String : Any]? = nil
        pthread_mutex_lock(&self.mutex)
        let diskUrl = URL(fileURLWithPath: self.diskPath)
        let subDiskUrl = diskUrl.appendingPathComponent(defaultName, isDirectory: true)
        do {
            guard let leveldb = LevelDBBridge(path: subDiskUrl.path) else{
                throw NSError()
            }
            dic = leveldb.convert { (data) -> Any? in
                return NSKeyedUnarchiver.unarchiveObject(with: data)
                } as? [String : Any]
        } catch {
            SwiftLvDB.printLog(log: "\(error)")
        }
        pthread_mutex_unlock(&self.mutex)
        return dic
    }
    
    func data(forKey defaultName: String) -> Data? {
        guard let leveldb = self.leveldb else {
            SwiftLvDB.printLog(log: "LevelDB init Error!!!!")
            return nil
        }
        var data:Data?
        pthread_mutex_lock(&self.mutex)
        data = leveldb.data(forKey: defaultName)
        pthread_mutex_unlock(&self.mutex)
        return data
    }
    
    func integer(forKey defaultName: String) -> Int {
        guard let data = self.data(forKey: defaultName) else {
            return 0
        }
        return data.to(type: Int.self)
    }
    
    func float(forKey defaultName: String) -> Float {
        guard let data = self.data(forKey: defaultName) else {
            return 0
        }
        return data.to(type: Float.self)
    }
    
    func double(forKey defaultName: String) -> Double {
        guard let data = self.data(forKey: defaultName) else {
            return 0
        }
        return data.to(type: Double.self)
    }
    
    func bool(forKey defaultName: String) -> Bool {
        guard let data = self.data(forKey: defaultName) else {
            return false
        }
        return data.to(type: Bool.self)
    }
    
    func set(_ value: Int, forKey defaultName: String) {
        self.set(value.data, forKey: defaultName)
    }
    
    func set(_ value: Float, forKey defaultName: String) {
        self.set(value.data, forKey: defaultName)
    }
    
    func set(_ value: Double, forKey defaultName: String) {
        self.set(value.data, forKey: defaultName)
    }
    
    func set(_ value: Bool, forKey defaultName: String) {
        self.set(value.data, forKey: defaultName)
    }
    
    func set(_ value: String, forKey defaultName: String) {
        guard let data = value.data(using: String.Encoding.utf8) else{
            return
        }
        self.set(data, forKey: defaultName)
    }
    
    func set(_ value: Data, forKey defaultName: String) {
        guard let leveldb = self.leveldb else {
            SwiftLvDB.printLog(log: "LevelDB init Error!!!!")
            return
        }
        pthread_mutex_lock(&self.mutex)
        leveldb.setData(value, forKey: defaultName)
        pthread_mutex_unlock(&self.mutex)
    }
    
    func set(_ value: [NSCoding], forKey defaultName: String) {
        let diskUrl = URL(fileURLWithPath: self.diskPath)
        let subDiskUrl = diskUrl.appendingPathComponent(defaultName, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: subDiskUrl, withIntermediateDirectories: true, attributes: nil)
            guard let leveldb = LevelDBBridge(path: subDiskUrl.path) else{
                throw NSError()
            }
            for item in value.enumerated() {
                let data = NSKeyedArchiver.archivedData(withRootObject: item.element)
                leveldb.setData(data, forKey: "\(defaultName)[\(item.offset)]")
            }
        } catch {
            SwiftLvDB.printLog(log: "\(error)")
        }
    }
    
    
    func set(_ value: [String : NSCoding], forKey defaultName: String) {
        let diskUrl = URL(fileURLWithPath: self.diskPath)
        let subDiskUrl = diskUrl.appendingPathComponent(defaultName, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: subDiskUrl, withIntermediateDirectories: true, attributes: nil)
            guard let leveldb = LevelDBBridge(path: subDiskUrl.path) else{
                throw NSError()
            }
            value.forEach { (key,object) in
                let data = NSKeyedArchiver.archivedData(withRootObject: object)
                leveldb.setData(data, forKey: key)
            }
        } catch {
            SwiftLvDB.printLog(log: "\(error)")
        }
    }
    
    

}

//Mark 基础类型的Byte转化
extension Data {
    
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
}


private protocol DataConvertible {
    var data: Data { get }
}

private extension DataConvertible {
    var data: Data {
        var value = self
        return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
}

extension Int : DataConvertible { }
extension Float : DataConvertible { }
extension Double : DataConvertible { }
extension Bool : DataConvertible { }
