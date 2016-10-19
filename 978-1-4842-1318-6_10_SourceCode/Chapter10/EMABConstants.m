//
//  EMABConstants.m
//  Chapter11
//
//  Created by Liangjun Jiang on 4/29/15.
//  Copyright (c) 2015 EMAB. All rights reserved.
//

#import "EMABConstants.h"
NSString *const kIsLoggedInfKey   = @"kIsLoggedIn";
NSString *const kParseApplicationID = @"YOUR-PARSE-APPLICATION-ID";
NSString *const kStripeTestPublishableKey = @"YOUR-STRIPE-TEST-PUBLISHABLE-KEY";
NSString *const kStripeTestSecretKey = @"YOUR-STRIPE-TEST-SECRET-KEY";
NSString *const kStripeLivePublishableKey = @"YOUR-STRIPE-LIVE-PUBLISHABLE-KEY";
NSString *const kStripeLiveSecretKey = @"YOUR-STRIPE-LIVE-SECRET-KEY";
NSString *const kMailgunAPIKey = @"YOUR-MAILGUN-API-KEY";
NSString *const kCategory = @"Category";
NSString *const kProduct = @"Product";
NSString *const kFavoriteProduct = @"FavoriteProduct";
NSString *const kOrder = @"Order";
NSString *const kOrderItem = @"OrderItem";

int const kMinTextLength = 6;
float const kLeftMargin = 20.0;
float const kTextFieldWidth = 260.0;
float const kTextFieldHeight = 30.0;
float const kTopMargin = 7.0;

@implementation EMABConstants
+(BOOL)isValidEmail:(NSString *)emailAdress{
    //https://github.com/benmcredmond/DHValidation
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAdress];
}
@end
