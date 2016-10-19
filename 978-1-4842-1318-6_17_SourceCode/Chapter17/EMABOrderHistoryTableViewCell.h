//
//  EMABOrderHistoryTableViewCell.h
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "PFTableViewCell.h"

@class EMABOrder;
@interface EMABOrderHistoryTableViewCell : PFTableViewCell

-(void)configureItem:(EMABOrder *)item;
@end
