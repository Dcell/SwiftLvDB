//
//  LevelDBBridge.h
//  SwiftLvDB
//
//  Created by Dcell on 2018/7/11.
//

#import <Foundation/Foundation.h>

typedef id _Nullable (^decode_block_t)(NSData *_Nonnull);

/**
 LevelDB 桥接，只负责字节数据的存储
 */
@interface LevelDBBridge : NSObject

/**
 初始化方式

 @param path 存储的磁盘路径
 @return leveldb 对象
 */
- (instancetype _Nullable )initWithPath:(NSString *_Nonnull)path;

- (NSData * _Nullable)dataForKey:(NSString *_Nonnull)key;
- (BOOL)setData:(NSData *_Nonnull)data forKey:(NSString *_Nonnull)key;
- (NSArray<NSData *>*_Nonnull)allValues;
- (NSArray<id>*_Nonnull)allObjectValues:(decode_block_t _Nonnull )byDecode;
- (NSArray<NSString *>*_Nonnull)allKeys;
- (NSDictionary *_Nonnull)convertToDictionary:(decode_block_t _Nonnull )byDecode;

@end
