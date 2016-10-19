//
//  EMABUserPaymentMethodTableViewController.h
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFQueryTableViewController.h>

@class EMABPaymentMethod;
typedef void (^CreditCardSelectionDidCancel)();
typedef void (^CreditCardSelectionDidFinish)(NSString *);

@interface EMABUserPaymentMethodTableViewController : PFQueryTableViewController
@property (nonatomic, copy) CreditCardSelectionDidCancel creditCardDidCancelBlock;
@property (nonatomic, copy) CreditCardSelectionDidFinish creditCardDidFinishBlock;

@property (nonatomic, assign) BOOL isModal;
@end
