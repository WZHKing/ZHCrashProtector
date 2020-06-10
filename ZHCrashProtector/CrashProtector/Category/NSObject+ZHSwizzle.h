//
//  NSObject+ZHSwizzle.h
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZHSwizzle)
+ (void)zh_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzleMethod:(SEL)swiSel;

+ (void)zh_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzleMethod:(SEL)swiSel;

+ (void)zh_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzleMethod:(SEL)swiSel cls:(Class)cls;

+ (void)zh_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzleMethod:(SEL)swiSel cls:(Class)cls;
@end
