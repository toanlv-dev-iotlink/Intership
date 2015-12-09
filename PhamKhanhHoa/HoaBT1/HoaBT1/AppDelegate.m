//
//  AppDelegate.m
//  HoaBT1
//
//  Created by MrHoa on 12/7/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    RootViewController *rootVC = [[RootViewController alloc] init];
    UINavigationController *rootNAV = [[UINavigationController alloc] initWithRootViewController: rootVC];
    self.window.rootViewController = rootNAV;
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
    [[CarData sharedData] saveContext];
}

@end
