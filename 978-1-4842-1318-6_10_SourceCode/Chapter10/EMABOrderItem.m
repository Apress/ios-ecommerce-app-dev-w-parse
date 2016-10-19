//
//  EMABOrderItem.m
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABOrderItem.h"
#import  <Parse/PFObject+Subclass.h>
#import "EMABConstants.h"
#import "EMABProduct.h"
@implementation EMABOrderItem
@dynamic quantity,product;
+(NSString *)parseClassName
{
    return kOrderItem;
}

-(double)subTotal {
    return self.quantity *self.product.unitPrice;
}

-(NSString *)friendlyQuantity {
    return [NSString stringWithFormat:@"X %lld",self.quantity];
}
@end
