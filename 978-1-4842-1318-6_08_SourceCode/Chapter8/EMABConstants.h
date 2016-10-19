//
//  EMABConstants.h
//  Chapter8
//
//  Created by Liangjun Jiang on 4/29/15.
//  Copyright (c) 2015 EMAB. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const kIsLoggedInfKey;
extern NSString *const kParseApplicationID;
extern NSString *const kParseClientKey;
extern NSString *const kStripeTestPublishableKey;
extern NSString *const kStripeTestSecretKey; //will not be used in this Xcode project
extern NSString *const kStripeLivePublishableKey;
extern NSString *const kStripeLiveSecretKey; //will not be used in this Xcode project
extern NSString *const kMailgunAPIKey;
extern NSString *const kCategory;
extern NSString *const kProduct;
extern NSString *const kFavoriteProduct;

extern int const kMinTextLength;
extern float const kLeftMargin;
extern float const kTextFieldWidth;
extern float const kTextFieldHeight;
extern float const kTopMargin;

@interface EMABConstants : NSObject
+(BOOL)isValidEmail:(NSString *)emailAdress;
@end
