//
//  CADisplayLink+Protector.h
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CADisplayLink (Protector)
+ (void)zh_enableDisplayLinkProtector;
@end
