//
//  EMABOrderItem.h
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <Parse/Parse.h>
@class EMABProduct;

@interface EMABOrderItem : PFObject<PFSubclassing>
@property (nonatomic, assign) int64_t quantity;
@property (nonatomic, strong) EMABProduct *product;

-(double)subTotal;

-(NSString *)friendlyQuantity;
@end
