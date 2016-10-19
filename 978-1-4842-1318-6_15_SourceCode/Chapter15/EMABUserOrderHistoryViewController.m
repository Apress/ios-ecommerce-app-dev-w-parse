//
//  EMABUserOrderHistoryViewController.m
//  Chapter18
//
//  Created by Liangjun Jiang on 7/12/15.
//  Copyright (c) 2015 EMAB. All rights reserved.
//

#import "EMABUserOrderHistoryViewController.h"
#import "EMABUser.h"
#import "EMABOrder.h"
#import "EMABOrderItem.h"
#import "EMABOrderHistoryTableViewCell.h"
#import "EMABOrderDetailTableViewController.h"
@interface EMABUserOrderHistoryViewController ()

@end

@implementation EMABUserOrderHistoryViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.parseClassName = kOrder;
    self.objectsPerPage = 10;
    self.paginationEnabled = YES;
    self.pullToRefreshEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Order History", @"Order History");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable {
    PFQuery *query = [EMABOrder queryForCustomer:[EMABUser currentUser] orderStatus:ORDER_MADE];
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    return query;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
- (EMABOrderHistoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(EMABOrder *)object{
    EMABOrderHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    [cell configureItem:object];
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if  ([segue.identifier isEqualToString:@"ShowOrderDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        EMABOrder *order = self.objects[indexPath.row];
        EMABOrderDetailTableViewController *viewController = segue.destinationViewController;
        [viewController setOrder:order];
    }
}

@end
