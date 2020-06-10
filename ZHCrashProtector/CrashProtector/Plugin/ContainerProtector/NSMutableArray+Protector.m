//
//  NSMutableArray+Protector.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

/**
*  1. - (id)objectAtIndex:(NSUInteger)index
*  2. - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
*  3. - (void)removeObjectAtIndex:(NSUInteger)index
*  4. - (void)insertObject:(id)anObject atIndex:(NSUInteger)index
*  5. - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
*/

#import "NSMutableArray+Protector.h"
#import "NSObject+ZHSwizzle.h"
#import "ZHCrashLog.h"

@implementation NSMutableArray (Protector)
+ (void)zh_enableMutableArrayProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSArrayM = NSClassFromString(@"__NSArrayM");
        
        // objectAtIndex:
        [self zh_swizzleInstanceMethodWithOriginSel:@selector(objectAtIndex:) swizzleMethod:@selector(zh_objectAtIndex:) cls:__NSArrayM];
        [self zh_swizzleInstanceMethodWithOriginSel:@selector(objectAtIndexedSubscript:) swizzleMethod:@selector(zh_objectAtIndexedSubscript:) cls:__NSArrayM];
        
        //insertObject:atIndex:
        [self zh_swizzleInstanceMethodWithOriginSel:@selector(insertObject:atIndex:) swizzleMethod:@selector(zh_insertObject:atIndex:) cls:__NSArrayM];

        //removeObjectAtIndex:
        [self zh_swizzleInstanceMethodWithOriginSel:@selector(removeObjectAtIndex:) swizzleMethod:@selector(zh_removeObjectAtIndex:) cls:__NSArrayM];

        //setObject:atIndexedSubscript:
        [self zh_swizzleClassMethodWithOriginSel:@selector(setObject:atIndexedSubscript:) swizzleMethod:@selector(zh_setObject:atIndexedSubscript:) cls:__NSArrayM];

        [self zh_swizzleInstanceMethodWithOriginSel:@selector(getObjects:range:) swizzleMethod:@selector(zh_getObjects:range:) cls:__NSArrayM];
    });
}

- (id)zh_objectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self zh_objectAtIndex:index];
    }
    @catch (NSException *exception) {
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
        [ZHCrashLog logWithException:exception];
    }
    @finally {
        return object;
    }
}

- (void)zh_insertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self zh_insertObject:anObject atIndex:index];
    }
    @catch (NSException *exception) {
        [ZHCrashLog logWithException:exception];
    }
    @finally {
    }
}

- (void)zh_removeObjectAtIndex:(NSUInteger)index {
    @try {
        [self zh_removeObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        [ZHCrashLog logWithException:exception];
    }
    @finally {
    }
}

- (void)zh_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @try {
        [self zh_setObject:obj atIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        [ZHCrashLog logWithException:exception];
    }
    @finally {
    }
}

- (void)zh_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self zh_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [ZHCrashLog logWithException:exception];
    }
    @finally {
    }
}
@end
