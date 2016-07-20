//
//  NSDictionary+EXtension.h
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (EXtension)

- (BOOL)isKindOfClass:(Class)aClass forKey:(NSString *)key;
- (BOOL)isMemberOfClass:(Class)aClass forKey:(NSString *)key;
- (BOOL)isArrayForKey:(NSString *)key;
- (BOOL)isDictionaryForKey:(NSString *)key;
- (BOOL)isStringForKey:(NSString *)key;
- (BOOL)isNumberForKey:(NSString *)key;

- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringNotNilForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;
- (NSNumber *)numberNotNilForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;
- (unsigned int)unsignedIntForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;
- (long long)longLongForKey:(NSString *)key;
- (unsigned long long)unsignedLongLongForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;


@end
