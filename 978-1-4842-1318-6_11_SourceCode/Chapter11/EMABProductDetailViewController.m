//
//  EMABProductDetailViewController.m
//  Chapter12
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABProductDetailViewController.h"
#import "EMABProduct.h"
#import <ParseUI/PFImageView.h>
#import "EMABFavoriteProduct.h"
#import "SVProgressHud.h"
#import "EMABOrderItem.h"
#import "EMABOrder.h"
#import "EMABUser.h"

@interface EMABProductDetailViewController ()
@property (nonatomic, weak) IBOutlet PFImageView *fullsizeImageView;
@property (nonatomic, weak) IBOutlet UILabel *productNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *productPriceLabel;
@property (nonatomic, weak) IBOutlet UITextView *detailTextView;
@property (nonatomic, weak) IBOutlet UIButton *heartButton;
@property (nonatomic, strong) EMABOrder *order;

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
    
    if ([EMABUser currentUser]) {
        [self queryForUnfinishedOrder];
    }

}

-(int)containsProduct:(NSArray *)items target:(EMABProduct *)product {
    int index = -1;
    for (int i = 0; i<[items count]; i++){
        EMABOrderItem *item = items[i];
        if ([item.product.objectId isEqualToString:self.product.objectId]) {
            index = i;
            break;
        }
    }
    
    return index;
}


-(IBAction)onBag:(id)sender
{
    if (![EMABUser currentUser]) {
        [self showWarning];
    } else {
        if (self.order) {
            if ([self.order.items count] > 0) {
                if ([self containsProduct:self.order.items target:self.product] > -1) {
                    int index = [self containsProduct:self.order.items target:self.product];
                    NSMutableArray *eItems = [NSMutableArray arrayWithArray:self.order.items];
                    EMABOrderItem *foundItem = eItems[index];
                    [foundItem setQuantity:foundItem.quantity+1];
                    [eItems replaceObjectAtIndex:index withObject:foundItem];
                    self.order.items = [eItems copy];
                } else {
                    [self.order addSingleProduct:self.product];
                }
            } else {
                [self.order addSingleProduct:self.product];
            }
        } else {
            self.order = [EMABOrder object];
            [self.order setCustomer:[EMABUser currentUser]];
            [self.order setOrderStatus:ORDER_NOT_MADE];
            [self.order addSingleProduct:self.product];
            
        }
    }
    __weak typeof(self) weakSelf = self;
    [self.order saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if (!error) {
            [weakSelf showSuccess];
        }
    }];

}


-(IBAction)onFavorite:(id)sender{
    if (![EMABUser currentUser]) {
        [self showWarning];
    } else {
        EMABFavoriteProduct *favoriteProduct = [EMABFavoriteProduct object];
        [favoriteProduct setCustomer:[EMABUser currentUser]];
        [favoriteProduct setProduct:self.product];
        __weak typeof(self) weakSelf = self;
        [favoriteProduct saveInBackgroundWithBlock:^(BOOL success, NSError *error){
            if (!error) {
                [weakSelf showSuccess];
            }
        }];
    }
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
    if ([EMABUser currentUser]) {
        PFQuery *fPQuery = [EMABFavoriteProduct queryForCustomer:[EMABUser currentUser] product:self.product];
        __weak typeof(self) weakSelf = self;
        [fPQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if (!error) {
                weakSelf.heartButton.enabled = false;
            } else {
                weakSelf.heartButton.enabled = true;
            }
        }];
    }
}


-(void)showWarning
{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please sign up or log in", @"")  maskType:SVProgressHUDMaskTypeBlack];
}

-(void)showSuccess{
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Successfully added", @"") maskType:SVProgressHUDMaskTypeBlack];
}


#pragma mark - Order not checkedout
-(void)queryForUnfinishedOrder{
    PFQuery *orderQuery = [EMABOrder queryForCustomer:[EMABUser currentUser] orderStatus:ORDER_NOT_MADE];
    
    __weak typeof(self) weakSelf = self;
    [orderQuery getFirstObjectInBackgroundWithBlock:^(PFObject *order, NSError *error){
        if (!error) {
            weakSelf.order = (EMABOrder *)order;
        }
    }];
}

//hear.png http://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Heart_coraz%C3%B3n.svg/2000px-Heart_coraz%C3%B3n.svg.png

@end
