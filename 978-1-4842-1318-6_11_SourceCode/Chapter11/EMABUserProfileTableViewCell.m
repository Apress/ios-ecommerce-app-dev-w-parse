//
//  EMABUserProfileTableViewCell.m
//  Chapter20
//
//  Created by Liangjun Jiang on 4/23/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABUserProfileTableViewCell.h"
#import "EMABConstants.h"
@implementation EMABUserProfileTableViewCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
//        CGRect frame = CGRectMake(100, kTopMargin, 210.0, kTextFieldHeight);
//        self.textField = [[UITextField alloc] initWithFrame:frame];
//        self.textField.borderStyle = UITextBorderStyleNone;
//        self.textField.textColor = [UIColor blackColor];
//        self.textField.font = [UIFont systemFontOfSize:13.0];
//        self.textField.textAlignment = NSTextAlignmentRight;
//        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        self.textField.enabled = NO;
//        self.textField.backgroundColor = [UIColor clearColor];
//        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
//        self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
//        self.textField.returnKeyType = UIReturnKeyDone;
//        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
//        
//        self.accessoryView = self.textField;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return self;
//}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        CGRect frame = CGRectMake(100, kTopMargin, 210.0, kTextFieldHeight);
        self.textField = [[UITextField alloc] initWithFrame:frame];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.textColor = [UIColor blackColor];
        self.textField.font = [UIFont systemFontOfSize:13.0];
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.enabled = NO;
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
        
        self.accessoryView = self.textField;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setContentForTableCellLabel:(NSString*)title placeHolder:(NSString *)placeHolder text:(NSString *)text keyBoardType:(NSNumber *)type enabled:(BOOL)enabled
{
    self.textLabel.text = title;
    self.textField.text = text;
    self.textField.placeholder = placeHolder;
    self.textField.keyboardType = [type intValue];
    
    self.textField.layer.cornerRadius = 4.0f;
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.borderColor = (enabled)?[[UIColor colorWithRed:0.0 green:153.0/255.0 blue:204.0/255.0 alpha:1] CGColor ]:[[UIColor clearColor] CGColor];
    self.textField.layer.borderWidth = 1.0f;
    self.textField.enabled = enabled;
    
}


@end
