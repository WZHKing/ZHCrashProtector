//
//  CADisplayLink+Protector.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import "CADisplayLink+Protector.h"
#import "NSObject+ZHSwizzle.h"
#import "ZHWeakProxy.h"

@implementation CADisplayLink (Protector)

+ (void)zh_enableDisplayLinkProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [CADisplayLink zh_swizzleClassMethodWithOriginSel:@selector(displayLinkWithTarget:selector:) swizzleMethod:@selector(zh_displayLinkWithTarget:selector:)];
    });
}

+ (CADisplayLink *)zh_displayLinkWithTarget:(id)target selector:(SEL)sel
{
    return [self zh_displayLinkWithTarget:[ZHWeakProxy proxyWithTarget:target] selector:sel];
}

@end
