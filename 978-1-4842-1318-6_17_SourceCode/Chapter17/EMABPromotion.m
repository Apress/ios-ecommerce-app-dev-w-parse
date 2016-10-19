//
//  EMABPromotion.m
//  Chapter15
//
//  Created by Liangjun Jiang on 4/22/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABPromotion.h"
#import <Parse/PFObject+Subclass.h>
#import "EMABConstants.h"
@implementation EMABPromotion
@dynamic content, image;

+(NSString *)parseClassName
{
    return kPromotion;
}

@end
