//
//  EMABUserPaymentMethodTableViewController.m
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABUserPaymentMethodTableViewController.h"
#import "EMABConstants.h"
#import "EMABUser.h"
#import "EMABPaymentMethod.h"
#import "EMABAddCreditCardViewController.h"
#import "SVProgressHud.h"
@interface EMABUserPaymentMethodTableViewController()
@property (nonatomic, strong) EMABPaymentMethod *selected;
@end

@implementation EMABUserPaymentMethodTableViewController
-(void)setIsModal:(BOOL)isModal
{
    _isModal = isModal;
    [self configureView];
}

-(void)configureView
{
    if (self.isModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.parseClassName = kPaymentMethod;
    self.objectsPerPage = 10;
    self.paginationEnabled = YES;
    self.pullToRefreshEnabled = YES;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [EMABPaymentMethod queryForOwner:[EMABUser currentUser]];
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    return query;
}

#pragma mark - IBAction
-(IBAction)onAdd:(id)sender
{
    EMABAddCreditCardViewController *viewController = (EMABAddCreditCardViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"EMABAddCreditCardViewController"];
    __weak typeof(self) weakSelf = self;
    viewController.finishBlock = ^(NSString *customerId){
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:viewController animated:YES];
    
}

#pragma mark - UITableView Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(EMABPaymentMethod *)object{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCell" forIndexPath:indexPath];
   
    cell.textLabel.text = [object friendlyCreditCardNumber];
    cell.detailTextLabel.text = [object friendlyExpirationMonthYear];
   
    if (object) {
        if (indexPath.row == 0){
            self.selected = object;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMABPaymentMethod *paymentMethod = (EMABPaymentMethod *)[self objectAtIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        [paymentMethod deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [weakSelf loadObjects];
            }
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger selectedIndex = [self.objects indexOfObject:self.selected];
    if (selectedIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        EMABPaymentMethod *creditCard =(EMABPaymentMethod *)[self objectAtIndexPath:indexPath];
        self.selected = creditCard;
        
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}


#pragma  mark - IBAction
-(void)onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)onDone:(id)sender
{
    self.creditCardDidFinishBlock(self.selected.stripeCustomerId);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
