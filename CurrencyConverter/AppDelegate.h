//
//  AppDelegate.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-14.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UITabBarController *mainTabController;
@property (strong, nonatomic) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;

@end
