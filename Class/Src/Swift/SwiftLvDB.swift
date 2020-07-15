//
//  SwiftLvDB.swift
//  SwiftLvDB
//
//  Created by Dcell on 2019/7/11.
//

import UIKit


final public class SwiftLvDB: NSObject {
    @objc public static let sharedInstance = SwiftLvDB()
    let memoryCache:LruMemoryCache
    let diskCache:DiskCacheProtocol
    init(path:String) {
        SwiftLvDB.printLog(log: "init path:\(path)")
        self.memoryCache = LruMemoryCache(maxCount: 200)
        self.diskCache = KeyValueDiskCache(path: path)
    }
    @objc public convenience init(subName:String) {
        //考虑到数据不能被系统清除，我们先缓存到文档文件，不缓存在Cache文件
        var diskPath = ""
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let diskURL = documentDirectory.appendingPathComponent(subName, isDirectory: true)
            try FileManager.default.createDirectory(at: diskURL, withIntermediateDirectories: true, attributes: nil)
            diskPath = diskURL.path
        } catch {SwiftLvDB.printLog(log: "\(error)")}
        self.init(path: diskPath)
    }
    private override convenience init() {
        let identifier = Bundle.main.bundleIdentifier ?? "SwiftLvDBDefault"
        self.init(subName: identifier)
    }
    
    
    /// -stringForKey: is equivalent to -objectForKey:, except that it will convert NSNumber values to their NSString representation. If a non-string non-number value is found, nil will be returned.
    @objc public func string(forKey defaultName: String) -> String?{
        if let value = self.memoryCache.getValue(defaultName) as? String{
            return value
        }
        if let value = self.diskCache.string(forKey: defaultName){
            self.memoryCache.setValue(value, defaultName)
            return value
        }
        return nil
    }
    
    
    /// -arrayForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray.
    @objc public func array(forKey defaultName: String) -> [Any]?{
        if let value = self.memoryCache.getValue(defaultName) as? [Any]{
            return value
        }
        if let value = self.diskCache.array(forKey: defaultName){
            self.memoryCache.setValue(value, defaultName)
            return value
        }
        return nil
    }
    
    
    /// -dictionaryForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSDictionary.
    @objc public func dictionary(forKey defaultName: String) -> [String : Any]?{
        if let value = self.memoryCache.getValue(defaultName) as? [String : Any]{
            return value
        }
        if let value = self.diskCache.dictionary(forKey: defaultName){
            self.memoryCache.setValue(value, defaultName)
            return value
        }
        return nil
    }
    
    /*!
     -objectForKey: will search the receiver's search list for a default with the key 'defaultName' and return it. If another process has changed defaults in the search list, NSUserDefaults will automatically update to the latest values. If the key in question has been marked as ubiquitous via a Defaults Configuration File, the latest value may not be immediately available, and the registered value will be returned instead.
     */
    @objc public func object(forKey defaultName: String) -> Any?{
        if let value = self.memoryCache.getValue(defaultName){
            return value
        }
        if let data = self.diskCache.data(forKey: defaultName){
            if let value = NSKeyedUnarchiver.unarchiveObject(with: data){
                self.memoryCache.setValue(value, defaultName)
                return value
            }
        }
        return nil
    }
    
    /// -dataForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSData.
    @objc func data(forKey defaultName: String) -> Data?{
        if let value = self.memoryCache.getValue(defaultName) as? Data{
            return value
        }
        if let value = self.diskCache.data(forKey: defaultName){
            self.memoryCache.setValue(value, defaultName)
            return value
        }
        return nil
    }
    
    /*!
     -integerForKey: is equivalent to -objectForKey:, except that it converts the returned value to an NSInteger. If the value is an NSNumber, the result of -integerValue will be returned. If the value is an NSString, it will be converted to NSInteger if possible. If the value is a boolean, it will be converted to either 1 for YES or 0 for NO. If the value is absent or can't be converted to an integer, 0 will be returned.
     */
    @objc public func integer(forKey defaultName: String) -> Int{
        if let value = self.memoryCache.getValue(defaultName) as? Int{
            return value
        }
        let value = self.diskCache.integer(forKey: defaultName)
        self.memoryCache.setValue(value, defaultName)
        return value
    }
    
    
    /// -floatForKey: is similar to -integerForKey:, except that it returns a float, and boolean values will not be converted.
    @objc public func float(forKey defaultName: String) -> Float{
        if let value = self.memoryCache.getValue(defaultName) as? Float{
            return value
        }
        let value = self.diskCache.float(forKey: defaultName)
        self.memoryCache.setValue(value, defaultName)
        return value
    }
    
    
    /// -doubleForKey: is similar to -integerForKey:, except that it returns a double, and boolean values will not be converted.
    @objc public func double(forKey defaultName: String) -> Double{
        if let value = self.memoryCache.getValue(defaultName) as? Double{
            return value
        }
        let value = self.diskCache.double(forKey: defaultName)
        self.memoryCache.setValue(value, defaultName)
        return value
    }
    
    
    /*!
     -boolForKey: is equivalent to -objectForKey:, except that it converts the returned value to a BOOL. If the value is an NSNumber, NO will be returned if the value is 0, YES otherwise. If the value is an NSString, values of "YES" or "1" will return YES, and values of "NO", "0", or any other string will return NO. If the value is absent or can't be converted to a BOOL, NO will be returned.
     
     */
    @objc public func bool(forKey defaultName: String) -> Bool{
        if let value = self.memoryCache.getValue(defaultName) as? Bool{
            return value
        }
        let value = self.diskCache.bool(forKey: defaultName)
        self.memoryCache.setValue(value, defaultName)
        return value
    }
    
    /// -setData:forKey: is equivalent to -setObject:forKey: except that the value is converted from a Data
    public func set(_ value: Data, forKey defaultName: String){
        self.memoryCache.setValue(value, defaultName)
        self.diskCache.set(value, forKey: defaultName)
    }
    
    
    /// -setInteger:forKey: is equivalent to -setObject:forKey: except that the value is converted from an NSInteger to an NSNumber.
    public func set(_ value: Int, forKey defaultName: String){
        self.memoryCache.setValue(value, defaultName)
        self.diskCache.set(value, forKey: defaultName)
    }
    
    
    /// -setFloat:forKey: is equivalent to -setObject:forKey: except that the value is converted from a float to an NSNumber.
    public func set(_ value: Float, forKey defaultName: String){
        self.memoryCache.setValue(value, defaultName)
        self.diskCache.set(value, forKey: defaultName)
    }
    
    
    /// -setDouble:forKey: is equivalent to -setObject:forKey: except that the value is converted from a double to an NSNumber.
    public func set(_ value: Double, forKey defaultName: String){
        self.memoryCache.setValue(value, defaultName)
        self.diskCache.set(value, forKey: defaultName)
    }
    
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a BOOL to an NSNumber.
    public func set(_ value: Bool, forKey defaultName: String){
        self.memoryCache.setValue(value, defaultName)
        self.diskCache.set(value, forKey: defaultName)
    }
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    public func set(_ value: String, forKey defaultName: String){
        self.memoryCache.setValue(value, defaultName)
        self.diskCache.set(value, forKey: defaultName)
    }
    
    /// -setData:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    public func set(_ value: NSCoding, forKey defaultName: String){
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        self.memoryCache.setValue(value, defaultName)
        self.diskCache.set(data, forKey: defaultName)
    }
    
    /// -setArray:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    public func set(_ value:[NSCoding],forKey defaultName: String){
        self.memoryCache.setValue(value, defaultName)
        self.diskCache.set(value, forKey: defaultName)
    }
    
    /// -setDictionary:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    public func set(_ value:[String:NSCoding],forKey defaultName: String){
        self.memoryCache.setValue(value, defaultName)
        self.diskCache.set(value, forKey: defaultName)
    }
}



extension SwiftLvDB{
    static func printLog(log:String){
        #if DEBUG
        print("[\(#file)]" + "[\(#function)]" + log)
        #endif
    }
}
