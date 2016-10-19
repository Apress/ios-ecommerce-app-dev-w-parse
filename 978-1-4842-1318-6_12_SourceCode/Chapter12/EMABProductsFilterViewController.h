//
//  EMABProductsFilterViewController.h
//  Chapter12
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMABProductsFilterViewController;
typedef void (^ViewControllerDidFinish)(EMABProductsFilterViewController *viewController, float minPrice, float maxPrice);

@interface EMABProductsFilterViewController : UIViewController
@property (nonatomic, copy) ViewControllerDidFinish finishBlock;

@end
