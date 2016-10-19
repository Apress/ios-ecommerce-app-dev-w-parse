//
//  EMABAddProductViewController.m
//  Chapter20
//
//  Created by Liangjun Jiang on 8/25/15.
//  Copyright (c) 2015 EMAB. All rights reserved.
//

#import "EMABAddProductViewController.h"
#import "EMABProduct.h"
#import "EMABUser.h"
#import <ParseUI/PFImageView.h>
#import "EMABAppDelegate.h"
#import "UIImage+Resize.h"
#import "EMABCategory.h"
#import "SVProgressHud.h"

#define KEYBOARD_HEIGHT 216.0

@interface EMABAddProductViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UIAlertViewDelegate>{
    UIImagePickerController * imagePickerController;
}
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet PFImageView *productImageView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *priceTextField;
@property (nonatomic, weak) IBOutlet UITextField *unitTextField;
@property (nonatomic, weak) IBOutlet UITextField *brandTextField;
@property (nonatomic, weak) IBOutlet UITextView *desciptionTextView;
@property (nonatomic, strong) EMABProduct *product;
@property (nonatomic, strong) EMABUser *owner;
@property (nonatomic, strong) NSArray *brands;
@property (nonatomic, strong) UIPickerView *brandPickerView;
@end

@implementation EMABAddProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fireUpBrands];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"New Product", @"New Product");
    
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.product = [EMABProduct object];
    
    
    
}

-(void)setupProductImageview
{
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onThumbnail:)];
    [self.productImageView addGestureRecognizer:portraitTap];
}


-(void)fireUpBrands
{
    
    __weak typeof(self) weakSelf = self;
    PFQuery *brandQuery = [EMABCategory basicQuery];
    [brandQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            weakSelf.brands = objects;
            weakSelf.brandTextField.inputView = weakSelf.brandPickerView;
        }
    }];
    
}


-(IBAction)onDone:(id)sender
{
    [self.desciptionTextView resignFirstResponder];
    self.product.name = self.nameTextField.text;
    self.product.unitPrice  = [self.priceTextField.text doubleValue];
    self.product.priceUnit = self.unitTextField.text;
    self.product.detail = self.desciptionTextView.text;
    if([self.product canSave]){
        [self.product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Saved  Successfully",@"")];
                
            } else{
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Info Missing", @"Info Missing")];
    }
}

-(IBAction)onCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource
-(UIPickerView *)brandPickerView{
    if (_brandPickerView ==nil) {
        _brandPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _brandPickerView.showsSelectionIndicator = YES;	// note this is default to NO
        
        _brandPickerView.tag = 121;
        // this view controller is the data source and delegate
        _brandPickerView.delegate = self;
        _brandPickerView.dataSource = self;
        
        
        // this animiation was from Apple Sample Code: DateCell
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        CGSize pickerSize = [_brandPickerView sizeThatFits:CGSizeZero];
        CGRect startRect = CGRectMake(0.0,
                                      screenRect.origin.y + screenRect.size.height,
                                      pickerSize.width, pickerSize.height);
        _brandPickerView.frame = startRect;
        
        // compute the end frame
        CGRect pickerRect = CGRectMake(0.0,
                                       screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                       pickerSize.width,
                                       pickerSize.height);
        
        // add some animation if you like
        _brandPickerView.frame = pickerRect;
    }
    
    return _brandPickerView;
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 121) {
        return  [self.brands count];
    }
    return 2;
}


#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 121) {
        EMABCategory *brand= self.brands[row];
        return brand.title;
    }
    return NSLocalizedString(@"No Data", @"No Data");
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 121) {
        EMABCategory *brand= self.brands[row];
        self.product.brand = brand;
        self.brandTextField.text = brand.title;
    }
}


#pragma mark - Keyboard Event Notifications

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    CGRect keyboardEndFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, KEYBOARD_HEIGHT);
    
    [UIView animateWithDuration:1.0 animations:nil completion:^(BOOL finished) {
        CGRect newFrame = self.view.frame;
        
        if (keyboardEndFrame.size.height >keyboardEndFrame.size.width)
        {   //we must be in landscape
            if (keyboardEndFrame.origin.x==0)
            {   //upside down so need to flip origin
                newFrame.origin = CGPointMake(keyboardEndFrame.size.width, 0);
            }
            
            newFrame.size.width -= keyboardEndFrame.size.width * (up?1:-1);
            
        } else
        {   //in portrait
            if (keyboardEndFrame.origin.y==0)
            {
                //upside down so need to flip origin
                newFrame.origin = CGPointMake(0, keyboardEndFrame.size.height);
            }
            CGPoint origin = CGPointMake(0, keyboardEndFrame.size.height* 0.7*(up?-1:0));
            newFrame.origin = origin;
        }
        self.view.frame = newFrame;
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self moveTextViewForKeyboard:nil up:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self moveTextViewForKeyboard:nil up:NO];
    return YES;
}


-(void)onThumbnail:(UITapGestureRecognizer *)recognizer{
            //ask to add new receipt
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Photo Source", @"Photo Source")
                                                                       message:NSLocalizedString(@"Choose One", @"Choose One")
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                             }];
        
        UIAlertAction* photoLibraryAction = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                                   }];
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
                                                             }];
        
        [alert addAction:cancelAction];
        [alert addAction:photoLibraryAction];
        [alert addAction:cameraAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    
    
}

- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
#pragma mark - ImagePickerController
-(IBAction)cancelPicture:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)shootPicture:(id)sender{
    [imagePickerController takePicture];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        CGRect frame =  [UIScreen mainScreen].applicationFrame;
        UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, frame.size.height-44, self.view.frame.size.width, 44)];
        
        toolBar.barStyle =  UIBarStyleBlackOpaque;
        NSArray *items=@[
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture:)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(shootPicture:)]
                         ];
        [toolBar setItems:items];
        
        // create the overlay view
        UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 64.0, frame.size.width, frame.size.height-44.0)];
        overlayView.opaque=NO;
        overlayView.backgroundColor=[UIColor clearColor];
        
        // parent view for our overlay
        UIView *cameraView=[[UIView alloc] initWithFrame:frame];
        [cameraView addSubview:overlayView];
        [cameraView addSubview:toolBar];
        
        
        imagePickerController.showsCameraControls = NO;
        imagePickerController.extendedLayoutIncludesOpaqueBars = YES;
        [imagePickerController setCameraOverlayView:cameraView];
        EMABAppDelegate* appDel = (EMABAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDel.tabBarController presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    } else
        [self.parentViewController presentViewController:imagePickerController animated:YES completion:nil];
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *fullsize = [UIImage imageWithImage:image scaledToWidth:1632];
    UIImage *thumbnail = [UIImage imageWithImage:fullsize scaledToWidth:408];
    
    self.productImageView.image = image;
    
    __weak typeof(self) weakSelf = self;
    
    PFFile *fullsizeFile = [PFFile fileWithName:@"fullszie.jpg" data:UIImageJPEGRepresentation(fullsize, 0.75)];
    
    [fullsizeFile saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if (!error) {
            weakSelf.product.fullsizeImage = fullsizeFile;
        }else {
            NSLog(@"error:%@",[error localizedDescription]);
        }
    }];
    PFFile *thumbnailFile = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(thumbnail, 0.75)];
    [thumbnailFile saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if (!error) {
            weakSelf.product.thumbnail = thumbnailFile;
        } else {
            NSLog(@"error:%@",[error localizedDescription]);
        }
    }];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
