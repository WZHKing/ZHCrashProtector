//
//  NSArray+Protector.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

/**
iOS 8:下都是__NSArrayI
iOS11: 之后分 __NSArrayI、  __NSArray0、__NSSingleObjectArrayI

iOS11之前：arr[]  调用的是[__NSArrayI objectAtIndexed]
iOS11之后：arr[]  调用的是[__NSArrayI objectAtIndexedSubscript]

arr为空数组
*** -[__NSArray0 objectAtIndex:]: index xxx beyond bounds for empty NSArray

arr只有一个元素
*** -[__NSSingleObjectArrayI objectAtIndex:]: index xxx beyond bounds [0 .. 0]
*/

#import "NSArray+Protector.h"
#import "NSObject+ZHSwizzle.h"
#import "ZHCrashLog.h"
#import <objc/runtime.h>

@implementation NSArray (Protector)
+ (void)zh_enableArrayProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSArray = objc_getClass("NSArray");
        Class __NSArrayI = objc_getClass("__NSArrayI");
        Class __NSSingleObjectArrayI = objc_getClass("__NSSingleObjectArrayI");
        Class __NSArray0 = objc_getClass("__NSArray0");
        
        [self zh_swizzleClassMethodWithOriginSel:@selector(arrayWithObjects:count:) swizzleMethod:@selector(zh_arrayWithObjects:count:) cls:__NSArray];
        
        /* arr.count >= 2 */
        // [arr objectAtIndex:]
        [self zh_swizzleInstanceMethodWithOriginSel:@selector(objectAtIndex:) swizzleMethod:@selector(zh_objectAtIndex:) cls:__NSArrayI];
        //arr[]
        [self zh_swizzleInstanceMethodWithOriginSel:@selector(objectAtIndexedSubscript:) swizzleMethod:@selector(zh_objectAtIndexedSubscript:) cls:__NSArrayI];
        
        /* arr.count == 0 */
        [self zh_swizzleInstanceMethodWithOriginSel:@selector(objectAtIndex:) swizzleMethod:@selector(zh_objectAtIndexedNullArray:) cls:__NSArray0];
        
        /* arr.count == 1 */
        [self zh_swizzleInstanceMethodWithOriginSel:@selector(objectAtIndex:) swizzleMethod:@selector(zh_objectAtIndexedOnlyOneCountArray:) cls:__NSSingleObjectArrayI];
        
        // objectsAtIndexes:
        [self zh_swizzleInstanceMethodWithOriginSel:@selector(objectsAtIndexes:) swizzleMethod:@selector(zh_objectsAtIndexes:) cls:__NSArray];
    });
}

+ (instancetype)zh_arrayWithObjects:(const id _Nonnull [_Nonnull])objects count:(NSUInteger)cnt
{
    id instance = nil;
    
    @try {
        instance = [self zh_arrayWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        //log exception
        [ZHCrashLog logWithException:exception];
        //把为nil的数据去掉,然后初始化数组
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self zh_arrayWithObjects:newObjects count:newObjsIndex];
    }
    @finally {
        return instance;
    }
}

- (id)zh_objectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self zh_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        //log exception
        [ZHCrashLog logWithException:exception];
    }
    @finally {
        return object;
    }
}

- (id)zh_objectAtIndexedSubscript:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self zh_objectAtIndexedSubscript:index];
    }
    @catch (NSException *exception) {
        //log exception
        [ZHCrashLog logWithException:exception];
    }
    @finally {
        return object;
    }
}

- (id)zh_objectAtIndexedNullArray:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self zh_objectAtIndexedNullArray:index];
    }
    @catch (NSException *exception) {
        //log exception
        [ZHCrashLog logWithException:exception];
    }
    @finally {
        return object;
    }
}

- (id)zh_objectAtIndexedOnlyOneCountArray:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self zh_objectAtIndexedOnlyOneCountArray:index];
    }
    @catch (NSException *exception) {
        //log exception
        [ZHCrashLog logWithException:exception];
    }
    @finally {
        return object;
    }
}

- (NSArray *)zh_objectsAtIndexes:(NSIndexSet *)indexes {
    NSArray *returnArray = nil;
    @try {
        returnArray = [self zh_objectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        //log exception
        [ZHCrashLog logWithException:exception];
    }
    @finally {
        return returnArray;
    }
}

@end
