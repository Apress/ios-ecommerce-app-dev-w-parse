//
//  EMABUserAccountTableViewController.m
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABUserAccountTableViewController.h"
#import "EMABUser.h"
#import "EMABUserPaymentMethodTableViewController.h"
#import "EMABUserProfileTableViewController.h"
#import "EMABAppDelegate.h"

typedef NS_OPTIONS(NSInteger, TABLE_ROW){
    SIGNED_IN = 0,
    CONTACT_INFO = 1,
    PAYMENT = 2,
    FAVORITE = 3,
    HISTORY
};

@interface EMABUserAccountTableViewController ()
@property (nonatomic, strong) EMABUser *customer;
@end

@implementation EMABUserAccountTableViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customer = [EMABUser currentUser];
    [self.customer fetchIfNeededInBackground];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return (self.customer && self.customer.isAdmin)?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return (self.customer)?5:1;
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *title = @"";
    NSString *subtitle = @"";
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case SIGNED_IN:
                title = (self.customer)?NSLocalizedString(@"Sign Out", @""):NSLocalizedString(@"Sign In", @"");
                subtitle = self.customer.email;
                break;
            case CONTACT_INFO:
                title = NSLocalizedString(@"Contact Info", @"");
                break;
            case PAYMENT:
                title = NSLocalizedString(@"Payment", @"");
                break;
            case FAVORITE:
                title = NSLocalizedString(@"Favorite", @"");
                break;
            case HISTORY:
                title = NSLocalizedString(@"Order History", @"");
                break;

            default:
                break;
        }
    } else {
        title = @"Add a product";
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    return cell;
}


#pragma mark - Navigation
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *viewControllerIdentifier = @"";
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case SIGNED_IN:
                if (self.customer) {
                    [self signOut];
                } else {
                    [self showSignIn];
                }
                break;
            case CONTACT_INFO:
                viewControllerIdentifier = @"EMABUserProfileTableViewController";
                break;
            case FAVORITE:
                viewControllerIdentifier = @"EMABUserFavoriteHistoryTableViewController";
                
                break;
            case HISTORY:
                viewControllerIdentifier = @"EMABUserOrderHistoryTableViewController";
                break;
            case PAYMENT:
                viewControllerIdentifier = @"EMABUserPaymentMethodTableViewController";
                break;
            default:
                break;
        }
    } else {
        viewControllerIdentifier = @"EMABAddProductViewController";
    }
    if ([viewControllerIdentifier length] > 0) {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

-(void)signOut {
    [EMABUser logOut];
    [self showSignIn];
    
}

-(void)showSignIn
{
    UIStoryboard *dispatchStoryboard = [UIStoryboard storyboardWithName:@"LoginSignup" bundle:nil];
    UINavigationController *navController = (UINavigationController *)[dispatchStoryboard instantiateInitialViewController];
    EMABAppDelegate *appDelegate = (EMABAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController presentViewController:navController animated:YES completion:nil];
}
@end
