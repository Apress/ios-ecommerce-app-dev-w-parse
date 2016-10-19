//
//  EMABProduct.m
//  Chapter9
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABProduct.h"
#import  <Parse/PFObject+Subclass.h>
#import "EMABConstants.h"
@implementation EMABProduct
@dynamic name, unitPrice, priceUnit, detail, thumbnail, fullsizeImage, brand;

+(NSString *)parseClassName
{
    return kProduct;
}

+(PFQuery *)basicQuery {
    PFQuery *query = [PFQuery queryWithClassName:[self parseClassName]];
    [query orderByAscending:@"name"];
    return query;
}


+(PFQuery *)queryForCategory:(EMABCategory *)brand{
    PFQuery  *query = [self basicQuery];
    [query whereKey:@"brand" equalTo:brand];
    return query;
}

-(NSString *)friendlyPrice{
    return [NSString localizedStringWithFormat:@"$ %.2f/%@", self.unitPrice, self.priceUnit];
}

+(PFQuery *)queryForCategory:(EMABCategory *)brand keyword:(NSString *)keyword
{
    PFQuery *query = [self queryForCategory:brand];
    [query whereKey:@"name" containsString:keyword];
    return query;
}

+(PFQuery *)queryForCategory:(EMABCategory *)brand minPrice:(float)min maxPrice:(float)max{
    PFQuery *query = [self queryForCategory:brand];
    [query whereKey:@"unitPrice" greaterThanOrEqualTo:@(min)];
    [query whereKey:@"unitPrice" lessThanOrEqualTo:@(max)];
    return query;
}
@end
