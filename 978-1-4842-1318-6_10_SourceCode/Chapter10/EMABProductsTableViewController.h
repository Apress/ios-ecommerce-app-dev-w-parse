//
//  EMABProductsTableViewController.h
//  Chapter11
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFQueryTableViewController.h>
@class EMABCategory;
@interface EMABProductsTableViewController : PFQueryTableViewController
@property (nonatomic, strong) EMABCategory *brand;
@end
