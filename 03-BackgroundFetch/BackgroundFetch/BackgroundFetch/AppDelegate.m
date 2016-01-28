//
//  AppDelegate.m
//  BackgroundFetch
//
//  Created by mac on 16/1/28.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //设定BackgroundFetch的频率
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // 1
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    // 2
    [application registerUserNotificationSettings:settings];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 3
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        // 4
        [application registerForRemoteNotifications];
    }
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
    // 清空
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@"clear badge");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

# pragma mark - background fetch delegate

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"performFetchWithCompletionHandler");
    
    //当后台获取被触发时，或调用下面的代码，这儿我直接去调用MainViewController的方法去刷新UI。
//    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//    ViewController *controller  = (ViewController *)navigationController.topViewController;
    
    ViewController *viewController = (ViewController *)self.window.rootViewController;
    NSUInteger insertNumber = [viewController insertStatusObjectsForFetchWithCompletionHandler:completionHandler];
    
    NSLog(@"added badge");
    //修改Icon的bageNumber提醒后台又刷新，强迫症者慎用
    NSInteger oldBadge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSLog(@"old badge num is %ld", (long)oldBadge);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber += insertNumber;
    
    NSInteger newBadge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSLog(@"new badge num is %ld", (long)newBadge);
}
@end
