//
//  EMABProductTableViewCell.h
//  Chapter14
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "PFTableViewCell.h"
@class EMABProduct;
@interface EMABProductTableViewCell : PFTableViewCell

-(void)configureItem:(EMABProduct *)product;

@end
