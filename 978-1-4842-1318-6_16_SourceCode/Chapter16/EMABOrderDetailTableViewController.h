//
//  EMABOrderDetailTableViewController.h
//  Chapter18
//
//  Created by Liangjun Jiang on 7/12/15.
//  Copyright (c) 2015 EMAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMABOrder;
@interface EMABOrderDetailTableViewController : UITableViewController

@property (nonatomic, strong) EMABOrder *order;
@end
