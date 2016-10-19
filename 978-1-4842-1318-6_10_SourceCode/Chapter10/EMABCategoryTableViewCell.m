//
//  EMABCategoryTableViewCell.m
//  Chapter11
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABCategoryTableViewCell.h"
#import <ParseUI/PFImageView.h>
#import "EMABCategory.h"

@interface EMABCategoryTableViewCell()
@property (nonatomic, weak) IBOutlet PFImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end;


@implementation EMABCategoryTableViewCell

-(void)configureItem:(EMABCategory *)item
{
    self.titleLabel.text = item.title;
    self.backgroundImageView.image = nil;
    if (item.image) {
        self.backgroundImageView.file = item.image;
        [self.backgroundImageView loadInBackground];
    } else {
        self.backgroundImageView.image = [UIImage imageNamed:@"category_cell_default_background"];
    }
    
}

@end
