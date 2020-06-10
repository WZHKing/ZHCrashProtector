//
//  ZHWeakProxy.h
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//
//参考YYWeakProxy

#import <Foundation/Foundation.h>

@interface ZHWeakProxy : NSProxy
@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;
@end
