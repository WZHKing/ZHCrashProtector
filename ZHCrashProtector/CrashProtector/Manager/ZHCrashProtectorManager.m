//
//  ZHCrashProtectorManager.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import "ZHCrashProtectorManager.h"
#import "NSObject+SelectorProtector.h"
#import "NSTimer+Protector.h"
#import "CADisplayLink+Protector.h"
#import "NSArray+Protector.h"
#import "NSMutableArray+Protector.h"
#import "NSDictionary+Protector.h"
#import "NSMutableDictionary+Protector.h"
#import "UIView+Protector.h"

@implementation ZHCrashProtectorManager
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static ZHCrashProtectorManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ZHCrashProtectorManager alloc] init];
    });
    return instance;
}
- (void)install
{
    [self install:ZHCrashProtectorPluginType_All];
}
- (void)install:(ZHCrashProtectorPluginType)pluginType
{
    switch (pluginType) {
        case ZHCrashProtectorPluginType_None:
            return;
        case ZHCrashProtectorPluginType_All:
            [self loadAllPlugin];
            break;
        case ZHCrashProtectorPluginType_UnrecognizedSelector:
            [self loadUnrecognizedSelectorPlugin];
            break;
        case ZHCrashProtectorPluginType_Timer:
            [self loadTimePlugin];
            break;
        case ZHCrashProtectorPluginType_Container:
            [self loadContainerPlugin];
            break;
        case ZHCrashProtectorPluginType_SubThreadUI:
            [self loadSubThreadUIPlugin];
        default:
            break;
    }
}

- (void)removeAllPlugin
{
    exit(0);
}

- (void)loadAllPlugin
{
    [self loadUnrecognizedSelectorPlugin];
    [self loadTimePlugin];
    [self loadContainerPlugin];
    [self loadSubThreadUIPlugin];
}

- (void)loadUnrecognizedSelectorPlugin
{
    [NSObject zh_enableSelectorProtector];
}

- (void)loadTimePlugin
{
    [NSTimer zh_enableTimerProtector];
    [CADisplayLink zh_enableDisplayLinkProtector];
}

- (void)loadContainerPlugin
{
    [NSArray zh_enableArrayProtector];
    [NSMutableArray zh_enableMutableArrayProtector];
    [NSDictionary zh_enableDictionaryProtector];
    [NSMutableDictionary zh_enableMutableDictionaryProtector];
}

- (void)loadSubThreadUIPlugin
{
    [UIView zh_enableSubThreadUIProtector];
}

@end
