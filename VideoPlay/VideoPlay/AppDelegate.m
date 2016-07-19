//
//  AppDelegate.m
//  VideoPlay
//
//  Created by 羊谦 on 16/7/18.
//  Copyright © 2016年 video. All rights reserved.
//

#import "AppDelegate.h"
#import "VDVideoRecordListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    VDVideoRecordListViewController *vc = [[VDVideoRecordListViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navc;
    [self.window makeKeyAndVisible];
    //注册bmob
    [Bmob registerWithAppKey:@"840f80f86e80b0df2eafdbdef3871cfd"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
