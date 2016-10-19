//
//  EMABCategoriesTableViewController.m
//  Chapter14
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABCategoriesTableViewController.h"
#import "EMABCategory.h"
#import "EMABCategoryTableViewCell.h"
#import "EMABConstants.h"
#import "EMABProductsTableViewController.h"
#import "EMABPromotion.h"
#import "EMABPromotionViewController.h"

@implementation EMABCategoriesTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.parseClassName = kCategory;
    self.objectsPerPage = 10;
    self.pullToRefreshEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidReceiveNotification:) name:kPromotionNotification object:nil];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [EMABCategory basicQuery];
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    return query;
}

#pragma mark - Table View

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
- (EMABCategoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(EMABCategory *)object{
    EMABCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    [cell configureItem:object];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewProducts"]) {
        EMABProductsTableViewController *viewController = segue.destinationViewController;
        NSIndexPath  *indexPath = [self.tableView indexPathForSelectedRow];
        [viewController setBrand:self.objects[indexPath.row]];
    }
    
    
}

#pragma mark - handle Push Notification Promotion

-(void)onDidReceiveNotification:(NSNotification *)notif {
    NSDictionary *notificationPayload  = notif.object;
    // Create a pointer to the Photo object
    if (notificationPayload) {
        NSString *objectId = [notificationPayload objectForKey:@"p"];
        EMABPromotion *promotion = (EMABPromotion *)[PFObject objectWithoutDataWithClassName:kPromotion
                                                                                    objectId:objectId];
        
        __weak typeof(self) weakSelf = self;
        [promotion fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            // Show promotion view controller
            if (!error) {
                EMABPromotionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EMABPromotionViewController"];
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            }
        }];
    }
    
}

@end
