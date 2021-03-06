//
//  EMABAppDelegate.m
//  Chapter4
//
//  Created by Liangjun Jiang on 4/29/15.
//  Copyright (c) 2015 EMAB. All rights reserved.
//

#import "EMABAppDelegate.h"
#import <Parse/Parse.h>
#import "EMABConstants.h"
#import "SVProgressHud.h"
@interface EMABAppDelegate ()<UITabBarControllerDelegate>

@end

@implementation EMABAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse setApplicationId:@"74ahhmaQqgos1TFCvVCSAjkaLv6ILY4CCPHDIoXh" clientKey:@"KdP1WZIwlPE0SaRVTL6JPFIFenTNNcRSP4v9BQ5a"];
    
//    [Parse setApplicationId:kParseApplicationID clientKey:kParseClientKey];
    
    UITabBarController *tabBarController = (UITabBarController*)self.window.rootViewController;
    tabBarController.delegate = self;
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kIsLoggedInfKey:@(NO)}];
//    [self addTestData];
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

#pragma mark - TabbarController Delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UINavigationController *navViewController = (UINavigationController *)viewController;
    if (![navViewController.title isEqualToString:@"Products"]) {
        if (!([[NSUserDefaults standardUserDefaults] boolForKey:kIsLoggedInfKey])) {
            UIStoryboard *dispatchStoryboard = [UIStoryboard storyboardWithName:@"LoginSignup" bundle:nil];
            UINavigationController *navController = (UINavigationController *)[dispatchStoryboard instantiateInitialViewController];
            [self.window.rootViewController presentViewController:navController animated:YES completion:nil];
        }
    }
}

-(void)addTestData {
    PFObject *product = [PFObject objectWithClassName:@"Product"];
    [product setObject:@"iOS eCommerce App Development with Parse" forKey:@"title"];
    [product setObject:@(19.99) forKey:@"unitPrice"];
    [product setObject:@"ea" forKey:@"priceUnit"];
    [product setObject:@"A real world iOS app development with Parse" forKey:@"subtitle"];
    [product saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Saved"];
        }
    }];
    
}

@end
