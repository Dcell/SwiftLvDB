//
//  DiskCache.swift
//  SwiftLvDB
//
//  Created by Dcell on 2018/7/11.
//

import UIKit

protocol DiskCacheProtocol:NSObjectProtocol{
    
//    init(path:String)
    /*!
     -objectForKey: will search the receiver's search list for a default with the key 'defaultName' and return it. If another process has changed defaults in the search list, NSUserDefaults will automatically update to the latest values. If the key in question has been marked as ubiquitous via a Defaults Configuration File, the latest value may not be immediately available, and the registered value will be returned instead.
     */
    func object(forKey defaultName: String) -> Any?
    
    
    /// -removeObjectForKey: is equivalent to -[... setObject:nil forKey:defaultName]
    func removeObject(forKey defaultName: String)
    
    
    /// -stringForKey: is equivalent to -objectForKey:, except that it will convert NSNumber values to their NSString representation. If a non-string non-number value is found, nil will be returned.
    func string(forKey defaultName: String) -> String?
    
    
    /// -arrayForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray.
    func array(forKey defaultName: String) -> [Any]?
    
    
    /// -dictionaryForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSDictionary.
    func dictionary(forKey defaultName: String) -> [String : Any]?
    
    
    /// -dataForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSData.
    func data(forKey defaultName: String) -> Data?
    
    
    
    
    /*!
     -integerForKey: is equivalent to -objectForKey:, except that it converts the returned value to an NSInteger. If the value is an NSNumber, the result of -integerValue will be returned. If the value is an NSString, it will be converted to NSInteger if possible. If the value is a boolean, it will be converted to either 1 for YES or 0 for NO. If the value is absent or can't be converted to an integer, 0 will be returned.
     */
    func integer(forKey defaultName: String) -> Int
    
    
    /// -floatForKey: is similar to -integerForKey:, except that it returns a float, and boolean values will not be converted.
    func float(forKey defaultName: String) -> Float
    
    
    /// -doubleForKey: is similar to -integerForKey:, except that it returns a double, and boolean values will not be converted.
    func double(forKey defaultName: String) -> Double
    
    
    /*!
     -boolForKey: is equivalent to -objectForKey:, except that it converts the returned value to a BOOL. If the value is an NSNumber, NO will be returned if the value is 0, YES otherwise. If the value is an NSString, values of "YES" or "1" will return YES, and values of "NO", "0", or any other string will return NO. If the value is absent or can't be converted to a BOOL, NO will be returned.
     
     */
    func bool(forKey defaultName: String) -> Bool
    

    
    
    /// -setInteger:forKey: is equivalent to -setObject:forKey: except that the value is converted from an NSInteger to an NSNumber.
    func set(_ value: Int, forKey defaultName: String)
    
    
    /// -setFloat:forKey: is equivalent to -setObject:forKey: except that the value is converted from a float to an NSNumber.
    func set(_ value: Float, forKey defaultName: String)
    
    
    /// -setDouble:forKey: is equivalent to -setObject:forKey: except that the value is converted from a double to an NSNumber.
    func set(_ value: Double, forKey defaultName: String)
    
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a BOOL to an NSNumber.
    func set(_ value: Bool, forKey defaultName: String)
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    func set(_ value: String, forKey defaultName: String)
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    func set(_ value: Data, forKey defaultName: String)
    
    /// -setArray:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    func set(_ value:[NSCoding],forKey defaultName: String)

    /// -setDictionary:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    func set(_ value:[String:NSCoding],forKey defaultName: String)
}
