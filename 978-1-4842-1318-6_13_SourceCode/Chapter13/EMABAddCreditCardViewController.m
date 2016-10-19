//
//  EMABAddCreditCardViewController.m
//  Chapter20
//
//  Created by Liangjun Jiang on 4/23/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABAddCreditCardViewController.h"
#import "Stripe.h"
#import "EMABUser.h"
#import "EMABPaymentMethod.h"
@interface EMABAddCreditCardViewController ()<STPPaymentCardTextFieldDelegate>
@property (nonatomic, weak) IBOutlet STPPaymentCardTextField *paymentView;
@end

@implementation EMABAddCreditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Authorize", @"") style:UIBarButtonItemStylePlain target:self action:@selector(onAuthorize:)];
}

- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = textField.isValid;
}

- (void)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onAuthorize:(id)sender {
    if (![self.paymentView isValid]) {
        return;
    }
    
    STPCard *card = [[STPCard alloc] init];
    card.number = self.paymentView.card.number;
    card.expMonth = self.paymentView.card.expMonth;
    card.expYear = self.paymentView.card.expYear;
    card.cvc = self.paymentView.card.cvc;
    
    __weak typeof(self) weakSelf = self;
    [[STPAPIClient sharedClient] createTokenWithCard:card
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                              } else {
                                                  EMABUser *user = [EMABUser currentUser];
                                                  NSDictionary *stripeCustomerDictionary = @{@"tokenId":token.tokenId,
                                                                                             @"customerEmail":user.email
                                                                                             };
                                                  [PFCloud callFunctionInBackground:@"createStripeCustomer" withParameters:stripeCustomerDictionary block:^(NSString *customerId, NSError *error) {
                                                      if (!error) {
                                                          EMABPaymentMethod *creditCard = [EMABPaymentMethod object];
                                                          creditCard.owner  = user;
                                                          creditCard.stripeCustomerId = customerId;
                                                          creditCard.expirationMonth = card.expMonth;
                                                          creditCard.expirationYear = card.expYear;
                                                          creditCard.type = [creditCard friendlyType:card.brand];
                                                          creditCard.lastFourDigit = card.last4;
                                                          creditCard.stripeCustomerId = customerId;
                                                          [creditCard saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                              if (!error) {
                                                                  [weakSelf readyToCharge:customerId];
                                                              }
                                                          }];
                                                      } else {
                                                          
                                                      }
                                                  }];
                                              }
                                          }];
}


-(void)readyToCharge:(NSString *)customerId {
    self.finishBlock(customerId);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
