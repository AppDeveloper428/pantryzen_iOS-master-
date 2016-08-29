//
//  AppDelegate.m
//  pantryzen
//
//  Created by admin on 14/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "AppDelegate.h"
#import "SDImageCache.h"
//#import <ZendeskSDK/ZendeskSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

//    self.arrMyCart = [NSMutableArray array];
    self.arrMyCart = [[NSMutableArray alloc] init];
    self._tmpDic = [[NSDictionary alloc] init];
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearMemory];
//    [[ZDKConfig instance]
//     initializeWithAppId:@"0baa1d0348c7dd3cda1faa9e92269c0ad54021f9c87ad151"
//     zendeskUrl:@"https://testco4.zendesk.com"
//     clientId:@"mobile_sdk_client_53bb3cf66b082e9e5ef4"];
//    ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
//    [ZDKConfig instance].userIdentity = identity;
//    [ZDKLogger enable:YES];
    return YES;
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

+ (AppDelegate *)sharedInstance {
    static AppDelegate *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    });
    return _sharedInstance;
}

@end
