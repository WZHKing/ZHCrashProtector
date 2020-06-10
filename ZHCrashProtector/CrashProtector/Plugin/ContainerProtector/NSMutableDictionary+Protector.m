//
//  NSMutableDictionary+Protector.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

/**
 * 1.- (void)removeObjectForKey:(KeyType)aKey;
 * 2.- (void)setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;
*/

#import "NSMutableDictionary+Protector.h"
#import "NSObject+ZHSwizzle.h"
#import "ZHCrashLog.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Protector)
+ (void)zh_enableMutableDictionaryProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dictionaryM = NSClassFromString(@"__NSDictionaryM");

        [self zh_swizzleInstanceMethodWithOriginSel:@selector(removeObjectForKey:) swizzleMethod:@selector(zh_removeObjectForKey:) cls:dictionaryM];
        [self zh_swizzleInstanceMethodWithOriginSel:@selector(setObject:forKey:) swizzleMethod:@selector(zh_setObject:forKey:) cls:dictionaryM];
    });
}

- (void)zh_removeObjectForKey:(id)aKey
{
    @try {
        [self zh_removeObjectForKey:aKey];
    } @catch (NSException *exception) {
        [ZHCrashLog logWithException:exception];
    } @finally {
    }
}

- (void)zh_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    @try {
        [self zh_setObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        [ZHCrashLog logWithException:exception];
    } @finally {
    }
}

@end
