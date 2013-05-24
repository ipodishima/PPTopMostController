//
//  AppDelegate.m
//  PPTopMostController
//
//  Created by Marian Paul on 24/05/13.
//  Copyright (c) 2013 iPuP. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabbar = [UITabBarController new];
    
    MainViewController *m1 = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *n1 = [[UINavigationController alloc] initWithRootViewController:m1];
    UITabBarItem *tb1 = [[UITabBarItem alloc] initWithTitle:@"Nav" image:nil tag:0];
    n1.tabBarItem = tb1;
    
    MainViewController *m2 = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UITabBarItem *tb2 = [[UITabBarItem alloc] initWithTitle:@"Simple" image:nil tag:1];
    m2.tabBarItem = tb2;
    
    [tabbar setViewControllers:@[n1, m2]];
    
    self.window.rootViewController = tabbar;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(showNotification) userInfo:nil repeats:YES];
    
    return YES;
}

- (void)showNotification {
    // You don't have to care about the view hierarchy
    (void)[NotificationView showWithText:@"Notification from Application delegate"
                                   color:[UIColor colorWithRed:0.447 green:0.006 blue:0.649 alpha:1.000]
                       andHideAfterDelay:3.0];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
