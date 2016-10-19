//
//  EMABProductsFilterViewController.m
//  Chapter12
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABProductsFilterViewController.h"
#import "SVProgressHud.h"
@interface EMABProductsFilterViewController (){
    float minPrice;
    float maxPrice;
}
@property (nonatomic, weak) IBOutlet UISlider *minSlider;
@property (nonatomic, weak) IBOutlet UISlider *maxSlider;

@property (nonatomic, weak) IBOutlet UILabel *minLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxLabel;

@end

@implementation EMABProductsFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    minPrice = 20.0;
    maxPrice = 200.0;
    
    self.minSlider.value = minPrice;
    self.maxSlider.value = maxPrice;
}


-(IBAction)onSlider:(id)sender{
    UISlider *slider = (UISlider *)sender;
    NSString *friendlySliderValue = [NSString stringWithFormat:@"$%.0f",slider.value];;
    if (slider.tag == 99) {
        minPrice = slider.value;
        self.minLabel.text = friendlySliderValue;
    } else {
        maxPrice = slider.value;
        self.maxLabel.text = friendlySliderValue;
    }
    
}

-(IBAction)onCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onDone:(id)sender{
    if (minPrice > 0 && minPrice > maxPrice) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please make sure your max price is greater than your min price.", @"")];
    } else {
        self.finishBlock(self, minPrice, maxPrice);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
