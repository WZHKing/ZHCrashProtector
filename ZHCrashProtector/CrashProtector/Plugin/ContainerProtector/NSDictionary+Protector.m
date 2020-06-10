//
//  NSDictionary+Protector.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//
#import "NSDictionary+Protector.h"
#import "NSObject+ZHSwizzle.h"
#import "ZHCrashLog.h"

/**
*  1. NSDictionary的快速创建方式 NSDictionary *dict = @{@"frameWork" : @"AvoidCrash"};
*  这种创建方式其实调用的是2中的方法
*  2. + (instancetype)dictionaryWithObjects:(const ObjectType _Nonnull [_Nullable])objects forKeys:(const KeyType <NSCopying> _Nonnull [_Nullable])keys count:(NSUInteger)cnt;
*
*/

@implementation NSDictionary (Protector)
+ (void)zh_enableDictionaryProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zh_swizzleClassMethodWithOriginSel:@selector(dictionaryWithObjects:forKeys:count:) swizzleMethod:@selector(zh_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)zh_dictionaryWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt
{
    id instance = nil;
    @try {
        instance = [self zh_dictionaryWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {

        [ZHCrashLog logWithException:exception];
        
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self zh_dictionaryWithObjects:newObjects forKeys:newkeys count:index];
    } @finally {
        return instance;
    }
}

@end
