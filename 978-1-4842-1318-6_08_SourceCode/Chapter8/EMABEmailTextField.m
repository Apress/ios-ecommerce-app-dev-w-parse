//
//  EMABm
//  Chapter11
//
//  Created by Liangjun Jiang on 4/21/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABEmailTextField.h"

@implementation EMABEmailTextField

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderStyle = UITextBorderStyleNone;
        self.textColor = [UIColor blackColor];
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.placeholder = NSLocalizedString(@"Email", @"");
        self.backgroundColor = [UIColor whiteColor];
        self.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
        
        self.keyboardType = UIKeyboardTypeEmailAddress;	// use the default type input method (entire keyboard)
        self.returnKeyType = UIReturnKeyDone;
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
        
        // Add an accessibility label that describes what the text field is for.
        [self setAccessibilityLabel:NSLocalizedString(@"Email", @"")];

    }
    
    return self;
    
}

@end
