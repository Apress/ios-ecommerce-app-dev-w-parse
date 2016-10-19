//
//  EMABOrderDetailTableViewController.m
//  Chapter15
//
//  Created by Liangjun Jiang on 7/12/15.
//  Copyright (c) 2015 EMAB. All rights reserved.
//

#import "EMABOrderDetailTableViewController.h"
#import "EMABOrder.h"
#import "EMABOrderItem.h"
#import "EMABProduct.h"
@interface EMABOrderDetailTableViewController ()
@property (nonatomic, weak) IBOutlet UILabel *ordeNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *ordeDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTextLabel;
@end

@implementation EMABOrderDetailTableViewController

-(void)setOrder:(EMABOrder *)order
{
    if (_order != order) {
        _order = order;
        
        [self configureView];
    }
    
}

-(void)configureView {
    self.ordeNoLabel.text = [self.order friendlyOrderNo];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.ordeDateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    self.totalLabel.text = [self.order friendlyTotal];
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Order Detail", @"Order Detail");
    [self configureView];
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
    return [self.order.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemCell" forIndexPath:indexPath];
    
    if (self.order) {
        EMABOrderItem *item = self.order.items[indexPath.row];
        cell.textLabel.text = item.product.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ x %lld",[item.product friendlyPrice], item.quantity];
    }
    return cell;
}



@end
