//
//  EMABcustomerProfileTableViewController.m
//  Chapter7
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABUserProfileTableViewController.h"
#import "EMABUserProfileTableViewCell.h"
#import "EMABUser.h"
#import "SVProgressHud.h"
static NSString *kTitleKey = @"titleKey";
static NSString *kPlaceholderKey = @"placeholderKey";
static NSString *kKeyboardKey = @"keyboardTypeKey";


@interface EMABUserProfileTableViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) EMABUser *customer;
@end

@implementation EMABUserProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArray = @[
                             @{
                                 kTitleKey:NSLocalizedString(@"First Name*", @"First Name"),
                                 kPlaceholderKey:NSLocalizedString(@"First Name", @"First Name"),
                                 kKeyboardKey:@(UIKeyboardTypeNamePhonePad)},
                             @{
                                 kTitleKey:NSLocalizedString(@"Last Name*",@""),
                                 kPlaceholderKey:NSLocalizedString(@"Last Name",@""),
                                 kKeyboardKey:@(UIKeyboardTypeNamePhonePad)},
                             
                             @{
                                 kTitleKey:NSLocalizedString(@"Phone*",@""),
                                 kPlaceholderKey:@"5555555555",
                                 kKeyboardKey:@(UIKeyboardTypePhonePad)},
                             
                             
                             @{
                                 kTitleKey:NSLocalizedString(@"Email*",@""),
                                 kPlaceholderKey:@"Email",
                                 kKeyboardKey:@(UIKeyboardTypeEmailAddress)},
                             
                             
                             @{
                                 kTitleKey:NSLocalizedString(@"Address 1*",@""),
                                 kPlaceholderKey:@"Address 1",
                                 kKeyboardKey:@(UIKeyboardTypeDefault)},
                             @{
                                 kTitleKey:NSLocalizedString(@"Address 2",@""),
                                 kPlaceholderKey:@"Address 2",
                                 kKeyboardKey:@(UIKeyboardTypeDefault)},
                             
                             @{
                                 kTitleKey:NSLocalizedString(@"City*",@""),
                                 kPlaceholderKey:NSLocalizedString(@"City",@""),
                                 kKeyboardKey:@(UIKeyboardTypeDefault)},
                             
                             @{
                                 kTitleKey:NSLocalizedString(@"Zipcode*",@""),
                                 kPlaceholderKey:@"#####",
                                 kKeyboardKey:@(UIKeyboardTypeNumberPad)},
                             @{
                                 kTitleKey:NSLocalizedString(@"State*",@""),
                                 kPlaceholderKey:NSLocalizedString(@"State",@""),
                                 kKeyboardKey:@(UIKeyboardTypeDefault)}
                             ];
    
    self.customer = [EMABUser currentUser];
}

-(IBAction)onDone:(id)sender
{
    [self.tableView.superview endEditing:YES];
    if ([self.customer isShippingAddressCompleted]) {
        __weak typeof(self) weakSelf = self;
        [self.customer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please complete the required information denoted by *",@"")];
    }
}

-(IBAction)onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray count];
}


- (EMABUserProfileTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMABUserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    cell.textField.delegate = self;
    cell.textField.tag = 100 + row;
    
    NSString *text = @"";
    switch (row) {
        case 0:
            text = self.customer.firstName;
            break;
        case 1:
            text = self.customer.lastName;
            break;
        case 2:
            text = self.customer.phone;
            break;
        case 3:
            text = self.customer.email;
            break;
        case 4:
            text = self.customer.address1;
            break;
        case 5:
            text = self.customer.address2;
            break;
        case 6:
            text = self.customer.city;
            break;
        case 7:
            text = self.customer.zipcode;
            break;
        case 8:
            text = self.customer.state;
            break;
        default:
            break;
    }
    
    NSString *title = self.dataSourceArray[row][kTitleKey];
    NSString *placeholder = self.dataSourceArray[row][kPlaceholderKey];
    NSNumber *keyboardType = self.dataSourceArray[row][kKeyboardKey];
    
    [cell setContentForTableCellLabel:title placeHolder:placeholder text:text keyBoardType:keyboardType enabled:YES];
    return cell;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 100:
            self.customer.firstName = textField.text;
            break;
        case 101:
            self.customer.lastName = textField.text;
            break;
        case 102:
            self.customer.phone = textField.text;
            break;
        case 103:
            self.customer.email = textField.text;
            break;
        case 104:
            self.customer.address1 = textField.text;
            break;
        case 105:
            self.customer.address2 = textField.text;
            break;
        case 106:
            self.customer.city = textField.text;
            break;
        case 108:
            self.customer.state = textField.text;
            break;
        case 107:
            self.customer.zipcode = textField.text;
            break;
        default:
            break;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
