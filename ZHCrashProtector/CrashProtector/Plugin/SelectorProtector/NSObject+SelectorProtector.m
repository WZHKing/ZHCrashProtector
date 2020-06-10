//
//  NSObject+SelectorProtector.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import "NSObject+SelectorProtector.h"
#import "NSObject+ZHSwizzle.h"
#import <objc/runtime.h>

@interface ZHSelectorProtectorObject : NSObject
@end

@implementation ZHSelectorProtectorObject

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    class_addMethod([self class], sel, (IMP)addInstanceMethod, "v@:@");
    return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    class_addMethod(object_getClass(self), sel, (IMP)addClassMethod, "v@:@");
    return YES;
}

id addInstanceMethod(id self, SEL _cmd)
{
    Class klass = object_getClass(self);
    NSLog(@"[%@ %@]: unrecognized selector send to instance %p", NSStringFromClass(klass), NSStringFromSelector(_cmd), self);
    return 0;
}

id addClassMethod(id self, SEL _cmd)
{
    NSLog(@"+ [%@ %@]: unrecognized selector send to class %p", NSStringFromClass(self), NSStringFromSelector(_cmd), self);
    return 0;
}

@end

@implementation NSObject (SelectorProtector)
+ (void)zh_enableSelectorProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject zh_swizzleInstanceMethodWithOriginSel:@selector(forwardingTargetForSelector:) swizzleMethod:@selector(zh_instance_forwardingTargetForSelector:)];
        [NSObject zh_swizzleClassMethodWithOriginSel:@selector(forwardingTargetForSelector:) swizzleMethod:@selector(zh_class_forwardingTargetForSelector:)];
    });
}

- (id)zh_instance_forwardingTargetForSelector:(SEL)aSelector
{
    if (class_respondsToSelector([self class], @selector(forwardInvocation:))) {
        //如果对象的类已重写了forwardInvocation方法的话，
        //就不应该对forwardingTargetForSelector进行重写，
        //否则会影响到该类型的对象原本的消息转发流程
        IMP impOfNSObject = class_getMethodImplementation([NSObject class], @selector(forwardInvocation:));
        IMP imp = class_getMethodImplementation([self class], @selector(forwardInvocation:));
        if (imp != impOfNSObject) {
            //NSLog(@"class has implemented invocation");
            return nil;
        }
    }
    return [ZHSelectorProtectorObject new];
}

- (id)zh_class_forwardingTargetForSelector:(SEL)aSelector
{
    if (class_respondsToSelector(object_getClass(self), @selector(forwardInvocation:))) {
        IMP impOfNSObject = class_getMethodImplementation(object_getClass([NSObject class]), @selector(forwardInvocation:));
        IMP imp = class_getMethodImplementation(object_getClass(self), @selector(forwardInvocation:));
        if (imp != impOfNSObject) {
            return nil;
        }
    }
    return [ZHSelectorProtectorObject class];
}
@end

