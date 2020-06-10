//
//  AppDelegate.m
//  ZHCrashProtector
//
//  Created by wzh on 2020/6/10.
//  Copyright © 2020 ZH. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ZHCrashProtectorManager.h"

@interface AppDelegate ()
{
    UIWindow *_window;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[ZHCrashProtectorManager shareInstance] install];
    
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];
    window.rootViewController = nv;
    [window makeKeyAndVisible];
    _window = window;
    return YES;
}




@end
