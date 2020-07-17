//
//  LevelDBBridge.m
//  SwiftLvDB
//
//  Created by Dcell on 2018/7/11.
//

#import "LevelDBBridge.h"
#import <leveldb/db.h>
#import <leveldb/options.h>
#import <leveldb/cache.h>
#import <leveldb/filter_policy.h>
#import <leveldb/write_batch.h>

NS_INLINE leveldb::Slice SliceByString(NSString *string)
{
    if (!string) return NULL;
    const char *cStr = [string UTF8String];
    size_t len = strlen(cStr);
    if (len == 0) return NULL;
    return leveldb::Slice(cStr,strlen(cStr));
}

@interface LevelDBBridge () {
    leveldb::DB * db;
    leveldb::ReadOptions readOptions;
    leveldb::WriteOptions writeOptions;
    const leveldb::Cache * cache;
    const leveldb::FilterPolicy * filterPolicy;
}

@end


@implementation LevelDBBridge

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            BOOL sucess = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                    withIntermediateDirectories:YES
                                                                     attributes:NULL
                                                                          error:NULL];
            if (!sucess)
            {
                return nil;
            }
        }
        leveldb::Options options;
        options.create_if_missing = YES;
        options.paranoid_checks = YES;
        options.error_if_exists = NO;
        
        leveldb::Status status = leveldb::DB::Open(options, [path UTF8String], &db);
        if(!status.ok()) {
            NSLog(@"Problem creating LevelDB database: %s", status.ToString().c_str());
            return nil;
        }
        readOptions.fill_cache = true;
        writeOptions.sync = false;
    }
    return self;
}

- (void)closeDb{
    delete db;
    db = NULL;
}

- (void)dealloc
{
    if(db){
        delete db;
        db = NULL;
    }
}

- (NSData *)dataForKey:(NSString *)key{
    leveldb::Slice sliceKey = SliceByString(key);
    std::string v_string;
    leveldb::Status status = db->Get(readOptions, sliceKey, &v_string);
    if (!status.ok()) return nil;
    return [[NSData alloc] initWithBytes:v_string.data() length:v_string.length()];
}
- (BOOL)setData:(NSData *)data forKey:(NSString *)key{
    leveldb::Slice sliceKey = SliceByString(key);
    leveldb::Slice sliceValue = leveldb::Slice((char *)[data bytes],[data length]);
    leveldb::Status status = db->Put(writeOptions, sliceKey, sliceValue);
    return status.ok();
}

- (NSArray<NSData *> *)allValues{
    leveldb::Iterator* it = db->NewIterator(leveldb::ReadOptions());
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (it->SeekToFirst(); it->Valid(); it->Next()) {
        NSData *data = [[NSData alloc] initWithBytes:it->value().data() length:it->value().size()];
        [array addObject:data];
    }
    delete it;
    return [array copy];
}

- (NSArray<id> *)allObjectValues:(decode_block_t)byDecode{
    leveldb::Iterator* it = db->NewIterator(leveldb::ReadOptions());
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (it->SeekToFirst(); it->Valid(); it->Next()) {
        NSData *data = [[NSData alloc] initWithBytes:it->value().data() length:it->value().size()];
        NSObject *object = byDecode(data);
        [array addObject:object];
    }
    delete it;
    return [array copy];
}

- (NSArray<NSString *> *)allKeys{
    leveldb::Iterator* it = db->NewIterator(leveldb::ReadOptions());
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (it->SeekToFirst(); it->Valid(); it->Next()) {
        NSString *key = [NSString stringWithUTF8String:it->key().data()];
        [array addObject:key];
    }
    delete it;    
    return [array copy];
}

- (NSDictionary *)convertToDictionary:(decode_block_t)byDecode{
    leveldb::Iterator* it = db->NewIterator(leveldb::ReadOptions());
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (it->SeekToFirst(); it->Valid(); it->Next()) {
        NSString *key = [NSString stringWithUTF8String:it->key().data()];
        NSData *data = [[NSData alloc] initWithBytes:it->value().data() length:it->value().size()];
        NSObject *object = byDecode(data);
        [dic setObject:object forKey:key];
    }
    delete it;
    return dic;
}

@end
