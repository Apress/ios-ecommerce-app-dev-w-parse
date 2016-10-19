//
//  EMABSignupViewController.m
//  Chapter14
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABSignupViewController.h"
#import "EMABConstants.h"
#import "EMABEmailTextField.h"
#import "EMABPasswordTextField.h"
#import "EMABUser.h"
@interface EMABSignupViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *passwordAgainTextField;
@property (nonatomic, weak) IBOutlet UITableView *signupTableView;
@end

@implementation EMABSignupViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emailTextField = [[EMABEmailTextField alloc] initWithFrame:CGRectMake(kLeftMargin, kTopMargin, kTextFieldWidth, kTextFieldHeight)];
    self.passwordTextField = [[EMABPasswordTextField alloc] initWithFrame:CGRectMake(kLeftMargin, kTopMargin, kTextFieldWidth, kTextFieldHeight)];
    self.passwordAgainTextField = [[EMABPasswordTextField alloc] initWithFrame:CGRectMake(kLeftMargin, kTopMargin, kTextFieldWidth, kTextFieldHeight)];
    [self.passwordAgainTextField setPlaceholder:NSLocalizedString(@"Password Again", @"Password Again")];
    
}


-(IBAction)onSignup:(id)sender{
    BOOL cont0 = [self.passwordTextField.text length] >= kMinTextLength;
    BOOL cont1 = [self.passwordAgainTextField.text length] >= kMinTextLength;
    BOOL cont2 = [self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text];
    BOOL cont3 = [self.emailTextField.text length] > kMinTextLength;
    BOOL cont4 = [EMABConstants isValidEmail:self.emailTextField.text];
    
    if (!cont0) {
        [self showWarning:NSLocalizedString(@"Password at least 6 characters.", @"Password at least 6 characters.")];
    }
    if (!cont1) {
        [self showWarning:NSLocalizedString(@"Password at least 6 characters.", @"Password at least 6 characters.")];
    }
    if (!cont2) {
        [self showWarning:NSLocalizedString(@"Passwords have to match.", @"Passwords have to match.")];
    }
    if (!cont3) {
        [self showWarning:NSLocalizedString(@"Email at least 6 characters.", @"Password at least 6 characters.")];
    }
    
    if (!cont4) {
        [self showWarning:NSLocalizedString(@"Doesn't look like a valid email.", @"Doesn't look like a valid email.")];
    }
    
    if (cont0 && cont1 && cont2 && cont3 && cont4) {
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.passwordAgainTextField resignFirstResponder];
        EMABUser *user = (EMABUser *)[PFUser user];
        user.username = [self.emailTextField text];
        user.email = [self.emailTextField text];
        user.password = [self.passwordTextField text];
        __weak typeof(self) weakSelf = self;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (!error) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"SignupCell" forIndexPath:indexPath];
    
    UITextField *textField = nil;
    switch (indexPath.row) {
        case 0:
            textField = self.emailTextField;
            break;
        case 1:
            textField = self.passwordTextField;
            break;
        case 2:
            textField = self.passwordAgainTextField;
            break;
        default:
            break;
    }
    
    // make sure this textfield's width matches the width of the cell
    CGRect newFrame = textField.frame;
    newFrame.size.width = CGRectGetWidth(cell.contentView.frame) - kLeftMargin*2;
    textField.frame = newFrame;
    
    // if the cell is ever resized, keep the textfield's width to match the cell's width
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [cell.contentView addSubview:textField];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - helper
-(void)showWarning:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Warning") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil , nil] show];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
