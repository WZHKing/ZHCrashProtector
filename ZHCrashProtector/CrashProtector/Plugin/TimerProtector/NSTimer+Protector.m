//
//  NSTimer+Protector.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import "NSTimer+Protector.h"
#import "NSObject+ZHSwizzle.h"
#import "ZHWeakProxy.h"

@implementation NSTimer (Protector)
+ (void)zh_enableTimerProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSTimer zh_swizzleClassMethodWithOriginSel:@selector(timerWithTimeInterval:target:selector:userInfo:repeats:) swizzleMethod:@selector(zh_timerWithTimeInterval:target:selector:userInfo:repeats:)];
        
        [NSTimer zh_swizzleClassMethodWithOriginSel:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) swizzleMethod:@selector(zh_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
    });
}

+ (NSTimer *)zh_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    return [self zh_timerWithTimeInterval:ti target: [ZHWeakProxy proxyWithTarget: aTarget] selector: aSelector userInfo:userInfo repeats: yesOrNo];
}


+ (NSTimer *)zh_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
{
    return [self zh_scheduledTimerWithTimeInterval:ti target: [ZHWeakProxy proxyWithTarget: aTarget] selector: aSelector userInfo:userInfo repeats: yesOrNo];
}
@end
