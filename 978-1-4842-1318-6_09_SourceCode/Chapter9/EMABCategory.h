//
//  EMABCategory.h
//  Chapter9
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <Parse/Parse.h>

@interface EMABCategory : PFObject<PFSubclassing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) PFFile *image;


+(PFQuery *)basicQuery;
@end
