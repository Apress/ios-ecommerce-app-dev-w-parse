//
//  EMABUser.m
//  Chapter14
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABUser.h"
#import  <Parse/PFObject+Subclass.h>
@implementation EMABUser
@dynamic firstName, lastName, name, gender, phone, address1, address2, city, state, zipcode, photo, isAdmin;

+(EMABUser *)currentUser{
    [super currentUser];
    return (EMABUser *)[PFUser currentUser];
}

-(BOOL)isShippingAddressCompleted{
    BOOL cont0 = self.firstName && self.lastName && [self.firstName length] > 0 && [self.lastName length] > 0;
    BOOL cont1 = self.address1 && [self.address1 length] > 0;
    BOOL cont2 = self.city && [self.city length] > 0;
    BOOL cont3 = self.state && [self.state length] > 0;
    BOOL cont4 = self.zipcode && [self.zipcode length]> 0;
    return cont0 && cont1 && cont1 && cont2 && cont3 && cont4;
}

@end
