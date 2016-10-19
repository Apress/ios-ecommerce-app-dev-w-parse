//
//  EMABUserProfileTableViewCell.h
//  Chapter20
//
//  Created by Liangjun Jiang on 4/23/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMABUserProfileTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *textField;
- (void)setContentForTableCellLabel:(NSString*)title placeHolder:(NSString *)placeHolder text:(NSString *)text keyBoardType:(NSNumber *)type enabled:(BOOL)enabled;
@end
