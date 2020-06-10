//
//  UIView+Protector.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import "UIView+Protector.h"
#import "NSObject+ZHSwizzle.h"

@implementation UIView (Protector)

+ (void)zh_enableSubThreadUIProtector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIView zh_swizzleInstanceMethodWithOriginSel:@selector(setNeedsLayout) swizzleMethod:@selector(zh_setNeedsLayout)];
        
        [UIView zh_swizzleInstanceMethodWithOriginSel:@selector(setNeedsDisplay) swizzleMethod:@selector(zh_setNeedsDisplay)];
        
        [UIView zh_swizzleInstanceMethodWithOriginSel:@selector(setNeedsDisplayInRect:) swizzleMethod:@selector(zh_setNeedsDisplayInRect:)];
    });
}

- (void)zh_setNeedsLayout
{
    if ([NSThread isMainThread]) {
        [self zh_setNeedsLayout];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self zh_setNeedsLayout];
        });
    }
}

- (void)zh_setNeedsDisplay
{
    if ([NSThread isMainThread]) {
        [self zh_setNeedsDisplay];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self zh_setNeedsDisplay];
        });
    }
}

- (void)zh_setNeedsDisplayInRect:(CGRect)rect
{
    if ([NSThread isMainThread]) {
        [self zh_setNeedsDisplayInRect:rect];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self zh_setNeedsDisplayInRect:rect];
        });
    }
}

@end

