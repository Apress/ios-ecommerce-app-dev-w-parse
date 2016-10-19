//
//  DispatchViewController.m
//  Chapter2
//
//  Created by Liangjun Jiang on 4/27/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABDispatchViewController.h"
#import "EMABConstants.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import "EMABUser.h"
#import "SVProgressHud.h"
@interface EMABDispatchViewController ()
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end

@implementation EMABDispatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(IBAction)onFacebookLogin:(id)sender{
    [self updateIndicator:YES];
    NSArray *permissionsArray = @[@"email",@"public_profile"];
    
    // Login PFUser using Facebook
    __weak typeof(self) weakSelf = self;
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else if (user.isNew) {
            [weakSelf obtainFacebookUserInfo:user];
        } else {
            [weakSelf obtainFacebookUserInfo:user];
        }
    }];
}

-(IBAction)onCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)obtainFacebookUserInfo:(PFUser *)user{
    
    [self updateIndicator:YES];
    __block EMABUser *fbUser = (EMABUser *)user;
    
    __weak typeof(self) weakSelf = self;
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            [fbUser setEmail:userData[@"email"]];
            [fbUser setUsername:userData[@"email"]?userData[@"email"]:userData[@"name"]];
            [fbUser setName:userData[@"name"]];
            if (userData[@"gender"]) {
                [fbUser setGender:userData[@"gender"]];
            }
            NSString *facebookID = userData[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            if ([pictureURL absoluteString]) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[pictureURL absoluteString]]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        PFFile *iconFile = [PFFile fileWithName:@"avatar.jpg" data:imageData];
                        [iconFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                fbUser.photo = iconFile;
                            }
                        }];
                        
                    });
                });
            }
            
            [fbUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }  if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                isEqualToString: @"OAuthException"]) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                [weakSelf showError:@"The facebook session was invalidated"];
            }];
        } else {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                [weakSelf showError:[error localizedDescription]];
            }];
        }
    }];
}


-(void)updateIndicator:(BOOL)shouldEnable{
    self.navigationItem.leftBarButtonItem.enabled = !shouldEnable;
    (shouldEnable)?[self.activityIndicatorView startAnimating]:[self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = !shouldEnable;
    
}

#pragma mark - helper
-(void)showError:(NSString *)message {
    [SVProgressHUD showErrorWithStatus:message];
}
@end
