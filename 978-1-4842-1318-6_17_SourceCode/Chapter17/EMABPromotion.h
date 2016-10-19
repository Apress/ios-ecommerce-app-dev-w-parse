//
//  EMABPromotion.h
//  Chapter15
//
//  Created by Liangjun Jiang on 4/22/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <Parse/Parse.h>

@interface EMABPromotion : PFObject<PFSubclassing>
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong)PFFile *image;
@end
