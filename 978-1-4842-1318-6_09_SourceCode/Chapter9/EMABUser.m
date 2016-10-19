//
//  EMABUser.m
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABUser.h"
#import  <Parse/PFObject+Subclass.h>
@implementation EMABUser
@dynamic firstName, lastName, name, gender, phone, address1, address2, city, state, zipcode, photo;

+(EMABUser *)currentUser{
    return (EMABUser *)[PFUser currentUser];
}

@end
