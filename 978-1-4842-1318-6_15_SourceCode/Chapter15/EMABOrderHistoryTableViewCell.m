//
//  EMABOrderHistoryTableViewCell.m
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABOrderHistoryTableViewCell.h"
#import "EMABOrder.h"

@interface EMABOrderHistoryTableViewCell()
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@end

@implementation EMABOrderHistoryTableViewCell

-(void)configureItem:(EMABOrder *)item
{
    if (item) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        self.dateLabel.text = [dateFormatter stringFromDate:item.updatedAt];
        self.totalLabel.text = [item friendlyTotal];
        
        self.nameLabel.text = [item.items[0] name];
    }
}

@end
