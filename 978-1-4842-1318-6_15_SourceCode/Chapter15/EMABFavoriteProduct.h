//
//  EMABFavoriteProduct.h
//  Chapter14
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <Parse/Parse.h>
@class EMABProduct;
@interface EMABFavoriteProduct : PFObject<PFSubclassing>
@property (nonatomic, strong) PFUser *customer;
@property (nonatomic, strong) EMABProduct *product;
+(PFQuery *)basicQuery;
+(PFQuery *)queryForCustomer:(PFUser *)customer;
+(PFQuery *)queryForCustomer:(PFUser *)customer product:(EMABProduct *)product;
@end
