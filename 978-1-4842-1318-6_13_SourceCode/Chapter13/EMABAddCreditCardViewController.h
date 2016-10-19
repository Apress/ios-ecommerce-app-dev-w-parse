//
//  EMABAddCreditCardViewController.h
//  Chapter20
//
//  Created by Liangjun Jiang on 4/23/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMABAddCreditCardViewController;
typedef void (^AddCreditCardViewControllerDidFinish)(NSString *customerId);

@interface EMABAddCreditCardViewController : UIViewController
@property (nonatomic, copy) AddCreditCardViewControllerDidFinish finishBlock;
@end
