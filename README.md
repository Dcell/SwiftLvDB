# [SwiftLvDB](https://github.com/Dcell/SwiftLvDB)
![SwiftLvDB CI](https://github.com/Dcell/SwiftLvDB/workflows/SwiftLvDB%20CI/badge.svg)
## **A fast key-value storage library , Leveldb for swift.**
* [x] support basic types [int,float,double,bool,string...]
* [x] support Object [Object:NSCode]
* [x] support List
* [x] support HashMap
* [x] support memory cache(LRU)

## Installation with CocoaPods

```
pod 'SwiftLvDB'
```
## Usage
Create SwiftLvDB Object
```
let sldb = SwiftLvDB.sharedInstance
or
let sldb = SwiftLvDB(subName: "sldb")
```
Set value for key

```
let testValue:String = "hello"
let testKey = "testSaveString"
SwiftLvDB.sharedInstance.set(testValue, forKey: testKey)
```
Get value for key

```
let testKey = "testSaveString"
let value = SwiftLvDB.sharedInstance.string(forKey: testKey)
```