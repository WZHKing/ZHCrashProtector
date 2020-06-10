//
//  ZHCrashLog.h
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHCrashLog : NSObject
+ (void)logWithException:(NSException *)exception;
@end
