//
//  EMABBagTableViewController.m
//  Chapter14
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
#import "EMABUserProfileTableViewController.h"
#import "EMABUserPaymentMethodTableViewController.h"
#import "EMABPaymentMethod.h"
#import "EMABAddCreditCardViewController.h"
#import "SVProgressHud.h"
@interface EMABBagTableViewController()<PKPaymentAuthorizationViewControllerDelegate>{
    BOOL hasCreditCard;
}
@property (nonatomic, weak) IBOutlet UILabel *ordeNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *ordeDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTextLabel;

@property (nonatomic, weak) IBOutlet UIButton *payWithCCButton;
@property (nonatomic, weak) IBOutlet UIButton *payWithApplePayButton;
@property (nonatomic, strong) EMABOrder *order;
@property (nonatomic, weak) NSArray *creditCards;
@property (nonatomic) NSDecimalNumber *amount;
@property (nonatomic, strong) PKPaymentRequest *paymentRequest;


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
    hasCreditCard = false;
    [self.refreshControl addTarget:self action:@selector(queryForUnfinishedOrder) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.order && self.order.isDirty) {
        [self.order saveInBackground];
    }
}

-(void)queryForPaymentMethod {
    PFQuery *paymentQuery = [EMABPaymentMethod queryForOwner:[EMABUser currentUser]];
    [paymentQuery findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error){
        if (!error) {
            if  ([object count] > 0)
                hasCreditCard = YES;
        }
    }];
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
                
                // we take time to get customer's payment
                [weakSelf queryForPaymentMethod];
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
    if ([[EMABUser currentUser] isShippingAddressCompleted]) {
        [self selectCreditCard];
    } else {
        EMABUserProfileTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EMABUserProfileTableViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }

    
}

-(IBAction)onApplePay:(id)sender{
    NSString *merchantId = kAppleMerchatID;
    self.paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:merchantId];
    if ([Stripe canSubmitPaymentRequest:self.paymentRequest]) {
        [self.paymentRequest setRequiredShippingAddressFields:PKAddressFieldPostalAddress];
        [self.paymentRequest setRequiredBillingAddressFields:PKAddressFieldPostalAddress];
        self.paymentRequest.paymentSummaryItems = [self summaryItemsForShippingMethod:nil];
        PKPaymentAuthorizationViewController *auth = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:self.paymentRequest];
        auth.delegate = self;
        if (auth) {
            [self presentViewController:auth animated:YES completion:nil];
        } else
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Something Wrong", @"Something Wrong")];
        
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Apple Pay is not enabled. Please enable your Apple Pay or Pay with Credit Card.", @"")];
    }

}

-(void)paymentAuthorizationViewControllerDidFinish:(nonnull PKPaymentAuthorizationViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self queryForUnfinishedOrder];
}

-(void)paymentAuthorizationViewController:(nonnull PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(nonnull PKPayment *)payment completion:(nonnull void (^)(PKPaymentAuthorizationStatus))completion{
    [self handlePaymentAuthorizationWithPayment:payment completion:nil];
    
}

- (void)handlePaymentAuthorizationWithPayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    [[STPAPIClient sharedClient] createTokenWithPayment:payment
                                             completion:^(STPToken *token, NSError *error) {
                                                 if (error) {
                                                     completion(PKPaymentAuthorizationStatusFailure);
                                                     return;
                                                 }
                                                 [self createBackendChargeWithToken:token completion:completion];
                                             }];
    
}

- (void)createBackendChargeWithToken:(STPToken *)token
                          completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    [self chargeWithToken:token.tokenId];
}

-(void)chargeWithToken:(NSString *)tokenId{
    [self.order saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if (!error) {
            __weak typeof(self) weakSelf = self;
            NSDictionary *params = @{@"chargeToken":tokenId, @"orderId":weakSelf.order.objectId};
            [PFCloud callFunctionInBackground:@"ChargeToken" withParameters:params block:^(NSString *message, NSError *error){
                if (!error) {
                    [weakSelf queryForUnfinishedOrder];
                }
            }];
        }
    }];
    
}

#pragma mark - Credit Card Helper
- (void)selectCreditCard
{
    if (hasCreditCard) {
        EMABUserPaymentMethodTableViewController *viewController = (EMABUserPaymentMethodTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"EMABUserPaymentMethodTableViewController"];
        viewController.isModal = YES;
        
        __weak typeof(self) weakSelf = self;
        viewController.creditCardDidFinishBlock = ^(NSString *customerId){
            [weakSelf charge:customerId];
        };
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        //we need to add a a credit card
        EMABAddCreditCardViewController *viewController = (EMABAddCreditCardViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"EMABAddCreditCardViewController"];
        __weak typeof(self) weakSelf = self;
        viewController.finishBlock = ^(NSString *customerId){
            [weakSelf charge:customerId];
        };
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

-(void)charge:(NSString *)customerId {
    [self.order saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if (!error) {
            NSDictionary *params = @{@"customerId":customerId, @"orderId":self.order.objectId};
            __weak typeof(self) weakSelf = self;
            [PFCloud callFunctionInBackground:@"Charge" withParameters:params block:^(NSString *message, NSError *error){
                if (!error) {
                    [weakSelf queryForUnfinishedOrder];
                }
            }];
        }
    }];
}

- (NSArray *)summaryItemsForShippingMethod:(PKShippingMethod *)shippingMethod {
    NSMutableArray *purchasedItems = [NSMutableArray arrayWithCapacity:[self.order.items count]];
    for (EMABOrderItem *item in self.order.items) {
        double total = item.quantity * item.product.unitPrice;
        NSString *readable = [NSString stringWithFormat:@"%.2f",total];
        NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:readable];
        PKPaymentSummaryItem *purchasedItem = [PKPaymentSummaryItem summaryItemWithLabel:item.product.name amount:price];
        [purchasedItems addObject:purchasedItem];
    }
    
    return [NSArray arrayWithArray:purchasedItems];
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
