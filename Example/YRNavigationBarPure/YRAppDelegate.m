//
//  YRAppDelegate.m
//  YRNavigationBarPure
//
//  Created by zongmumask on 09/02/2020.
//  Copyright (c) 2020 zongmumask. All rights reserved.
//

#import "YRAppDelegate.h"
#import "YRViewController.h"

@implementation YRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[YRViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}
@end
