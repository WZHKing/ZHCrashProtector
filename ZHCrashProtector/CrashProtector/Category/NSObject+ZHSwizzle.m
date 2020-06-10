//
//  NSObject+ZHSwizzle.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import "NSObject+ZHSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (ZHSwizzle)
+ (void)zh_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzleMethod:(SEL)swiSel
{
    Class cls = object_getClass(self);
    Method oriMethod = class_getClassMethod(cls, oriSel);
    Method swiMethod = class_getClassMethod(cls, swiSel);
    [self swizzleMethodWithOriginSel:oriSel
                           oriMethod:oriMethod
                         swizzledSel:swiSel
                      swizzledMethod:swiMethod
                               class:cls];
}

+ (void)zh_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzleMethod:(SEL)swiSel
{
    Method oriMethod = class_getInstanceMethod(self, oriSel);
    Method swiMethod = class_getInstanceMethod(self, swiSel);
    [self swizzleMethodWithOriginSel:oriSel
                           oriMethod:oriMethod
                         swizzledSel:swiSel
                      swizzledMethod:swiMethod
                               class:self];
}

+ (void)zh_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzleMethod:(SEL)swiSel cls:(Class)cls
{
    Class klass = object_getClass(cls);
    Method oriMethod = class_getClassMethod(klass, oriSel);
    Method swiMethod = class_getClassMethod(klass, swiSel);
    [self swizzleMethodWithOriginSel:oriSel
                           oriMethod: oriMethod
                         swizzledSel:swiSel
                      swizzledMethod:swiMethod
                               class:klass];
}

+ (void)zh_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzleMethod:(SEL)swiSel cls:(Class)cls
{
    Method oriMethod = class_getInstanceMethod(cls, oriSel);
    Method swiMethod = class_getInstanceMethod(cls, swiSel);
    [self swizzleMethodWithOriginSel:oriSel
                           oriMethod: oriMethod
                         swizzledSel:swiSel
                      swizzledMethod:swiMethod
                               class:cls];
}


+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        //原方法未实现，则替换原方法防止crash
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}
@end
