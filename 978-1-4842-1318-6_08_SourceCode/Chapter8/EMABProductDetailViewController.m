//
//  EMABProductDetailViewController.m
//  Chapter8
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABProductDetailViewController.h"
#import "EMABProduct.h"
#import <ParseUI/PFImageView.h>
#import "EMABFavoriteProduct.h"
#import "SVProgressHud.h"

@interface EMABProductDetailViewController ()
@property (nonatomic, weak) IBOutlet PFImageView *fullsizeImageView;
@property (nonatomic, weak) IBOutlet UILabel *productNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *productPriceLabel;
@property (nonatomic, weak) IBOutlet UITextView *detailTextView;
@property (nonatomic, weak) IBOutlet UIButton *heartButton;
@end

@implementation EMABProductDetailViewController

-(void)setProduct:(EMABProduct *)product{
    if (_product !=product) {
        _product = product;
        
        [self updateUI];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

-(void)updateUI{
    if (self.product.fullsizeImage) {
       self.fullsizeImageView.file = self.product.fullsizeImage;
        [self.fullsizeImageView loadInBackground];
    }
    
    self.productNameLabel.text = self.product.name;
    self.productPriceLabel.text = [self.product friendlyPrice];
    self.detailTextView.text = [self.product detail];
    self.title = self.product.name;
}


-(IBAction)onBag:(id)sender
{
    [self showWarning];
}


-(IBAction)onFavorite:(id)sender{
    [self showWarning];
}


-(IBAction)onShare:(id)sender {
    
    NSString *textToShare = [NSString stringWithFormat:@"%@, %@", self.product.name, [self.product friendlyPrice]];
    NSURL *imageUrl = [NSURL URLWithString:self.product.fullsizeImage.url];
    
    NSArray *objectsToShare = @[textToShare, imageUrl];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - helper
-(void)checkIfFavorited
{
    if (![PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        PFQuery *fPQuery = [EMABFavoriteProduct queryForCustomer:[PFUser currentUser] product:self.product];
        [fPQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if (!error) {
                self.heartButton.enabled = false;
            }
        }];
    }
}


-(void)showWarning
{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please sign up or log in", @"")  maskType:SVProgressHUDMaskTypeBlack];
}

//hear.png http://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Heart_coraz%C3%B3n.svg/2000px-Heart_coraz%C3%B3n.svg.png

@end
