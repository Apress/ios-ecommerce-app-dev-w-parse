//
//  EMABAppDelegate.m
//  Chapter14
//
//  Created by Liangjun Jiang on 4/29/15.
//  Copyright (c) 2015 EMAB. All rights reserved.
//

#import "EMABAppDelegate.h"
#import <Parse/Parse.h>
#import "EMABConstants.h"
#import "SVProgressHud.h"
#import "EMABCategory.h"
#import "EMABProduct.h"
#import "EMABFavoriteProduct.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import "EMABUser.h"
#import "EMABOrder.h"
#import "EMABOrderItem.h"
#import "EMABPaymentMethod.h"
#import "EMABPromotion.h"
#import "EMABPromotionViewController.h"
@interface EMABAppDelegate ()<UITabBarControllerDelegate>

@end

@implementation EMABAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [EMABCategory registerSubclass];
    [EMABProduct registerSubclass];
    [EMABFavoriteProduct registerSubclass];
    [EMABUser registerSubclass];
    [EMABOrderItem registerSubclass];
    [EMABOrder registerSubclass];
    [EMABPaymentMethod registerSubclass];
    [EMABPromotion registerSubclass];
    
    
    [Parse setApplicationId:@"74ahhmaQqgos1TFCvVCSAjkaLv6ILY4CCPHDIoXh" clientKey:@"KdP1WZIwlPE0SaRVTL6JPFIFenTNNcRSP4v9BQ5a"];
//     [Parse setApplicationId:kParseApplicationID clientKey:kParseClientKey];

    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

    UITabBarController *tabBarController = (UITabBarController*)self.window.rootViewController;
    tabBarController.delegate = self;
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    // track open
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
    
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]){
        NSDictionary *payload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if ([payload objectForKey:@"p"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPromotionNotification object:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
        }
    }

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

#pragma mark - Push Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}


#pragma mark Facebook SDK Integration

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma mark - TabbarController Delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UINavigationController *navViewController = (UINavigationController *)viewController;
    if (![navViewController.title isEqualToString:@"Products"]) {
        if (![EMABUser currentUser]) {
                UIStoryboard *dispatchStoryboard = [UIStoryboard storyboardWithName:@"LoginSignup" bundle:nil];
                UINavigationController *navController = (UINavigationController *)[dispatchStoryboard instantiateInitialViewController];
                [self.window.rootViewController presentViewController:navController animated:YES completion:nil];
        }
    }
    
}



@end
