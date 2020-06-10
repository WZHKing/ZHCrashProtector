//
//  ZHCrashProtectorManager.h
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZHCrashProtectorPluginType) {
    ZHCrashProtectorPluginType_None = 0,
    ZHCrashProtectorPluginType_All,
    ZHCrashProtectorPluginType_UnrecognizedSelector,
    ZHCrashProtectorPluginType_Timer,
    ZHCrashProtectorPluginType_Container,
    ZHCrashProtectorPluginType_SubThreadUI,
};

@interface ZHCrashProtectorManager : NSObject
+ (instancetype)shareInstance;
- (void)install;
- (void)install:(ZHCrashProtectorPluginType)pluginType;
- (void)removeAllPlugin;
@end
