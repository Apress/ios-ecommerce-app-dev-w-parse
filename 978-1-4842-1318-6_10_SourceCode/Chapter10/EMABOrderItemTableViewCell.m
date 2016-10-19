//
//  EMABOrderItemTableViewCell.m
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABOrderItemTableViewCell.h"
#import "EMABOrderItem.h"
#import "EMABProduct.h"
@interface EMABOrderItemTableViewCell()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *unitPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property (nonatomic, weak) IBOutlet UIStepper *quantityStepper;
@end

@implementation EMABOrderItemTableViewCell
-(void)configureItem:(EMABOrderItem *)item tag:(long)tag{
    if (item) {
        self.nameLabel.text = item.product.name;
        self.unitPriceLabel.text = [item.product friendlyPrice];
        self.quantityLabel.text = [item friendlyQuantity];
        self.quantityStepper.hidden = NO;
        self.quantityStepper.value = item.quantity;
        self.quantityStepper.stepValue = 1;
        self.quantityStepper.tag = tag + 100;
    } else {
        self.nameLabel.text = @"";
        self.unitPriceLabel.text = @"";
        self.quantityLabel.text = @"";
        self.quantityStepper.hidden = YES;
    }
    
}
@end
