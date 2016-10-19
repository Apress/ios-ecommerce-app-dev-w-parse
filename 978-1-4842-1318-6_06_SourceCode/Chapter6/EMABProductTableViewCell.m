//
//  EMABProductTableViewCell.m
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABProductTableViewCell.h"
#import <ParseUI/PFImageView.h>
#import "EMABProduct.h"
@interface EMABProductTableViewCell()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet PFImageView *thumbnailImageView;
@end

@implementation EMABProductTableViewCell


-(void)configureItem:(EMABProduct *)product{
    self.nameLabel.text = product.name;
    self.priceLabel.text = [product friendlyPrice];
    self.thumbnailImageView.image = nil;
    if (product.thumbnail) {
        self.thumbnailImageView.file = product.thumbnail;
        [self.thumbnailImageView loadInBackground];
    } else
        self.thumbnailImageView.image = [UIImage imageNamed:@"default_product_thumbnail"];
    
}
@end
