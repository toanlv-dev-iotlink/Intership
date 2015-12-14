//
//  AppDelegate.m
//  ParentChildContext
//
//  Created by Z on 12/14/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "AppDelegate.h"
#import "StudentDAO.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    RootViewController *rootVC = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = NVC;
    [self.window makeKeyAndVisible];
    
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
    [[CoreDataManager shared] saveContext];
}



@end
