//
//  ViewController.h
//  NNLogin
//
//  Created by Scott Twichel on 8/22/14.
//  Copyright (c) 2014 PepperGum Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNAnalyticsController.h"

@interface ViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource, UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *existingUserPicker;
- (IBAction)tappedNewPlayer:(id)sender;
- (IBAction)tappedStart:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *NewPlayerView;

#pragma mark -
#pragma mark Outlets located on NewPlayerView
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *ageTxt;
@property (weak, nonatomic) IBOutlet UITextField *raceTxt;
@property (weak, nonatomic) IBOutlet UITextField *nativeLanguageTxt;
- (IBAction)tappedCreateNewPlayer:(id)sender;
- (IBAction)tappedExitNewPlayerCreation:(id)sender;

@end
