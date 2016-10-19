//
//  EMABCategory.m
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABCategory.h"
#import  <Parse/PFObject+Subclass.h>
#import "EMABConstants.h"
@implementation EMABCategory
@dynamic title, image;

+(NSString *)parseClassName
{
    return kCategory;
}

+(PFQuery *)basicQuery{
    PFQuery *query = [PFQuery queryWithClassName:[self parseClassName]];
    [query orderByAscending:@"title"];
    return query;
    
}
@end
