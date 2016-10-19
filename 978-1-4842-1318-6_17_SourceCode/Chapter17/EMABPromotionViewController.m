//
//  EMABPromotionViewController.m
//  Chapter15
//
//  Created by Liangjun Jiang on 4/22/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABPromotionViewController.h"
#import "EMABPromotion.h"
#import <ParseUI/PFImageView.h>

@interface EMABPromotionViewController ()
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet PFImageView *imageView;
@end

@implementation EMABPromotionViewController

-(void)setPromotion:(EMABPromotion *)promotion
{
    if (_promotion != promotion) {
        _promotion = promotion;
        
        [self configureView];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}


-(void)configureView {
    self.contentLabel.text = self.promotion.content;
    if (self.promotion.image) {
        self.imageView.file = self.promotion.image;
        [self.imageView loadInBackground];
    }
}

-(IBAction)onDone:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
 
}

@end
