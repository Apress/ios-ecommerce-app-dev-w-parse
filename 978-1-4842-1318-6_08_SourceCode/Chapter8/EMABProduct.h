//
//  EMABProduct.h
//  Chapter8
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <Parse/Parse.h>
@class EMABCategory;
@interface EMABProduct : PFObject<PFSubclassing>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) double unitPrice;
@property (nonatomic, copy) NSString *priceUnit;
@property (nonatomic, strong) PFFile *thumbnail;
@property (nonatomic, strong) PFFile *fullsizeImage;

@property (nonatomic, strong) EMABCategory *brand;

+(PFQuery *)queryForCategory:(EMABCategory *)brand;

-(NSString *)friendlyPrice;

+(PFQuery *)queryForCategory:(EMABCategory *)brand keyword:(NSString *)keyword;

+(PFQuery *)queryForCategory:(EMABCategory *)brand minPrice:(float)min maxPrice:(float)max;


@end
