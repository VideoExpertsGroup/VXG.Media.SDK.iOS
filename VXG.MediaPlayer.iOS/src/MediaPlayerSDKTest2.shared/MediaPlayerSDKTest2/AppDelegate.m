/*
 * Copyright (c) 2011-2017 VXG Inc.
 */

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController *vc = [[MainViewController alloc] init];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navVc;
    [self.window makeKeyAndVisible];

    LoggerApp(1, @"Application didFinishLaunchingWithOptions");

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    LoggerApp(1, @"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
