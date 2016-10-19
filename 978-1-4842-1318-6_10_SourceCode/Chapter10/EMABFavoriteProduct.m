//
//  EMABFavoriteProduct.m
//  Chapter11
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABFavoriteProduct.h"
#import  <Parse/PFObject+Subclass.h>
#import "EMABConstants.h"
#import "EMABProduct.h"
@implementation EMABFavoriteProduct
@dynamic customer, product;
+(NSString *)parseClassName
{
    return kFavoriteProduct;
}

+(PFQuery *)basicQuery
{
    PFQuery *query = [PFQuery queryWithClassName:[self parseClassName]];
    [query orderByDescending:@"createdAt"];
    return query;
}

+(PFQuery *)queryForCustomer:(PFUser *)customer {
    PFQuery *query = [self basicQuery];
    [query whereKey:@"customer" equalTo:customer];
    return query;
    
}

+(PFQuery *)queryForCustomer:(PFUser *)customer product:(EMABProduct *)product
{
    PFQuery *query = [self queryForCustomer:customer];
    [query whereKey:@"product" equalTo:product];
    return query;
}

@end
