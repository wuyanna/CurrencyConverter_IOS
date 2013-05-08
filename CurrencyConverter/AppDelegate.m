//
//  AppDelegate.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-14.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "AppDelegate.h"
#import "CalViewController.h"
#import "RateTblViewController.h"
#import "CurrencyHelper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[CurrencyHelper sharedInstance] refreshRate];
    
    self.mainTabController = [[UITabBarController alloc] init];
    CalViewController *calView = [[CalViewController alloc] init];
    UINavigationController *calNav = [[UINavigationController alloc]initWithRootViewController:calView];
    RateTblViewController *rateTblView = [[RateTblViewController alloc] init];
    UINavigationController *rateNav = [[UINavigationController alloc]initWithRootViewController:rateTblView];
    [self.mainTabController setViewControllers:[NSArray arrayWithObjects:calNav, rateNav, nil]];
    [self.window addSubview:self.mainTabController.view];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
