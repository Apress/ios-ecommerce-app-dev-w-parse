//
//  EMABPasswordTextField.m
//  Chapter14
//
//  Created by Liangjun Jiang on 4/21/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABPasswordTextField.h"

@implementation EMABPasswordTextField

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderStyle = UITextBorderStyleNone;
        self.textColor = [UIColor blackColor];
        self.placeholder = NSLocalizedString(@"Password",@"");
        self.backgroundColor = [UIColor whiteColor];
        
        self.keyboardType = UIKeyboardTypeDefault;
        self.returnKeyType = UIReturnKeyDone;
        self.secureTextEntry = YES;	// make the text entry secure (bullets)
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
        [self setAccessibilityLabel:NSLocalizedString(@"Password", @"")];
    }
    
    return self;
    
}

@end
