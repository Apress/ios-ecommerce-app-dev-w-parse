//
//  EMABBagTableViewController.m
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABBagTableViewController.h"
#import "EMABOrderItemTableViewCell.h"
#import "EMABConstants.h"
#import "EMABUser.h"
#import "EMABOrder.h"
#import "EMABOrderItem.h"
#import "EMABProduct.h"
@interface EMABBagTableViewController(){
}
@property (nonatomic, weak) IBOutlet UILabel *ordeNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *ordeDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTextLabel;

@property (nonatomic, weak) IBOutlet UIButton *payWithCCButton;
@property (nonatomic, weak) IBOutlet UIButton *payWithApplePayButton;
@property (nonatomic, strong) EMABOrder *order;
@end

@implementation EMABBagTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([EMABUser currentUser]) {
        [self queryForUnfinishedOrder];
    }
}

-(void)viewDidLoad
{
    [self.refreshControl addTarget:self action:@selector(queryForUnfinishedOrder) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.order && self.order.isDirty) {
        [self.order saveInBackground];
    }
}

-(IBAction)queryForUnfinishedOrder {
    self.order = nil; //to get ride of the cache
    PFQuery *orderQuery = [EMABOrder queryForCustomer:[EMABUser currentUser] orderStatus:ORDER_NOT_MADE];
    
    __weak typeof(self) weakSelf = self;
    [orderQuery getFirstObjectInBackgroundWithBlock:^(PFObject *order, NSError *error){
        if ([weakSelf.refreshControl isRefreshing]) {
            [weakSelf.refreshControl endRefreshing];
        }
        
        if (!error) {
            if (order) {
                weakSelf.order = (EMABOrder *)order;
                weakSelf.ordeNoLabel.text = @"";
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
                weakSelf.ordeDateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
                weakSelf.totalLabel.text = [self.order friendlyTotal];
                [weakSelf updateUI];
            } else {
                [weakSelf updateUI];
            }
            
        } else {
            [weakSelf updateUI];
        }
    }];
}

-(void)updateUI {
    BOOL shouldClear = self.order == nil;
    if (shouldClear) {
        self.ordeNoLabel.text = NSLocalizedString(@"Your bag is empty.", @"");
        self.ordeDateLabel.text = @"";
        self.totalLabel.text = @"";
        self.totalTextLabel.text = @"";
        self.payWithApplePayButton.hidden = YES;
        self.payWithCCButton.hidden = YES;
        self.payWithApplePayButton.enabled = NO;
        self.payWithCCButton.enabled = NO;
    } else {
        self.totalTextLabel.text = NSLocalizedString(@"Total: ", @"");
        self.payWithApplePayButton.hidden = NO;
        self.payWithCCButton.hidden = NO;
        self.payWithApplePayButton.enabled = YES;
        self.payWithCCButton.enabled = YES;
    }
    [self.tableView reloadData];
    
}

-(IBAction)onPayWithCreditCard:(id)sender{
    //todo
    
}

-(IBAction)onApplePay:(id)sender{
    //todo
    
}

-(void)charge{
    //cloud code
    
}


-(IBAction)onStepper:(id)sender {
    UIStepper *stepper = (UIStepper *)sender;
    NSInteger index = stepper.tag - 100;
    NSMutableArray *orderItems = [NSMutableArray arrayWithArray:self.order.items];
    EMABOrderItem *orderItem = orderItems[index];
    orderItem.quantity = (int)stepper.value;
    
    if ((int)stepper.value == 0) {
        [orderItems removeObjectAtIndex:index];
    } else {
        [orderItems replaceObjectAtIndex:index withObject:orderItem];
    }
    
    if ([orderItems count] == 0) {
        [self showDeleteAlert];
    } else {
        self.order.items = [orderItems copy];
        [self.tableView reloadData];
        self.totalLabel.text = [self.order friendlyTotal];
    }
    
}

#pragma mark - UITableView Data Source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.order.items count];
}


- (EMABOrderItemTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMABOrderItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BagItemCell" forIndexPath:indexPath];
 
    if (self.order) [cell configureItem:self.order.items[indexPath.row] tag:indexPath.row];
    else [cell configureItem:nil tag:indexPath.row];
    return cell;
}


-(void)showDeleteAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Empty Bag",@"")
                                                                   message:NSLocalizedString(@"Are you sure you want to empty your bag?",@"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes",@"") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [weakSelf.order deleteInBackgroundWithBlock:^(BOOL success, NSError *error){
                                                                  if (!error) {
                                                                      [weakSelf queryForUnfinishedOrder];
                                                                  }
                                                              }];
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel",@"") style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
