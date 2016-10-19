//
//  EMABPaymentMethod.h
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <Parse/Parse.h>
#import "Stripe.h"
@class EMABUser;
@interface EMABPaymentMethod : PFObject<PFSubclassing>
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *stripeCustomerId;
@property (nonatomic, copy) NSString *lastFourDigit;
@property (nonatomic, assign) int64_t expirationMonth;
@property (nonatomic, assign)int64_t expirationYear;
@property (nonatomic, strong) EMABUser *owner;
-(NSString *)friendlyCreditCardNumber;
-(NSString *)friendlyExpirationMonthYear;
+(PFQuery *)basicQuery;
+(PFQuery *)queryForOwner:(EMABUser *)owner;
-(NSString *)friendlyType:(STPCardBrand)brand;
@end
