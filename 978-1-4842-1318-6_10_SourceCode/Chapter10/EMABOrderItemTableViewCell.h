//
//  EMABOrderItemTableViewCell.h
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMABOrderItem;
@interface EMABOrderItemTableViewCell : UITableViewCell
-(void)configureItem:(EMABOrderItem *)item tag:(long)tag;
@end
