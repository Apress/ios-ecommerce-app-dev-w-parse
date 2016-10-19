//
//  EMABCategoryTableViewCell.h
//  Chapter8
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "PFTableViewCell.h"
@class EMABCategory;
@interface EMABCategoryTableViewCell : PFTableViewCell
-(void)configureItem:(EMABCategory *)item;
@end
