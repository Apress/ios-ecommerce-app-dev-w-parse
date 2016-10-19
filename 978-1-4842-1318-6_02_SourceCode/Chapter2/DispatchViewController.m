//
//  DispatchViewController.m
//  Chapter2
//
//  Created by Liangjun Jiang on 4/27/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "DispatchViewController.h"
#import "AppDelegate.h"
@interface DispatchViewController ()

@end

@implementation DispatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(IBAction)onFacebookLogin:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLoggedInfKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
