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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customer = [EMABUser currentUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (self.customer)?5:1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *title = @"";
    NSString *subtitle = @"";
    switch (indexPath.row) {
        case SIGNED_IN:
            title = (self.customer)?NSLocalizedString(@"Sign In", @""): NSLocalizedString(@"Sign Out", @"");
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
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    return cell;
}


#pragma mark - Navigation
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *viewControllerIdentifier = @"";
    switch (indexPath.row) {
        case SIGNED_IN:
            if (self.customer) {
                [tableView deselectRowAtIndexPath:indexPath animated:nil];
            } else {
                [self signOut];
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
    if ([viewControllerIdentifier length] > 0) {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

-(void)signOut {
    [EMABUser logOut];
    [self.tableView reloadData];
}
@end
