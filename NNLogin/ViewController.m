//
//  ViewController.m
//  NNLogin
//
//  Created by Scott Twichel on 8/22/14.
//  Copyright (c) 2014 PepperGum Games. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, newPlayerFields) {
    NPFirstName,
    NPLastName,
    NPAge,
    NPRace,
    NPNativeLang
};
@interface ViewController (){
    NSMutableArray *playerList;//holds data to be used in picker view
    NSMutableArray *existingPlayers;//holds dictionaries of existing player details
    NSString *filePath;//file path to existingUsers.txt
}
@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    playerList = [NSMutableArray new];
    
    // Check to see if an existingPlayers file is present in the documents directory
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [path stringByAppendingPathComponent:@"existingUsers.txt"];
    BOOL fileExists =[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (fileExists) {
        existingPlayers = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        for (NSDictionary *player in existingPlayers) {
            [playerList addObject:[NSString stringWithFormat:@"%@ %@",[player objectForKey:@"first_name"],[player objectForKey:@"last_name"]]];
        }
    }
    else{
        existingPlayers = [NSMutableArray new];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBAction Methods
- (IBAction)tappedCreateNewPlayer:(id)sender {
    NSString *firstName = self.firstNameTxt.text;
    NSString *lastInitial = self.lastNameTxt.text;
    NSString *age = self.ageTxt.text;
    NSString *race = self.raceTxt.text;
    NSString *nativeLang = self.nativeLanguageTxt.text;

    if ([firstName isEqual: @""]|| ![self validData:firstName field:NPFirstName]) {
        [self validationError:@"first name"];
        [self.firstNameTxt becomeFirstResponder];
        return;
    }
    else if ([lastInitial isEqual: @""]|| ![self validData:lastInitial field:NPLastName]) {
        [self validationError:@"last initial"];
        [self.lastNameTxt becomeFirstResponder];
        return;
    }
    else if ([age isEqual: @""]|| ![self validData:age field:NPAge]) {
        [self validationError:@"age"];
        [self.ageTxt becomeFirstResponder];
        return;
    }
    else if ([race isEqual: @""]|| ![self validData:race field:NPAge]) {
        [self validationError:@"race"];
        [self.raceTxt becomeFirstResponder];
        return;
    }
    else if ([nativeLang isEqual: @""]|| ![self validData:nativeLang field:NPNativeLang]) {
        [self validationError:@"native language"];
        [self.nativeLanguageTxt becomeFirstResponder];
        return;
    }
    else
    {
        NSString *timeCreated = [self dateCreated];
        NSString *userName = [NSString stringWithFormat:@"%@%@%@",firstName,lastInitial,timeCreated];
        NSDictionary *playerDetails = [[NSDictionary alloc]initWithObjectsAndKeys:
                                       userName,    @"user_name",
                                       firstName,   @"first_name",
                                       lastInitial, @"last_name",
                                       age,         @"age",
                                       race,        @"race",
                                       nativeLang,  @"native_Language",
                                       timeCreated, @"created",
                                       nil];
        // TODO: Confirm login credentials and API error messages and uncomment code below
        // When the following code is uncommented, it the playerDetails dictionary will
        // be serialized into JSON and posted to the web service
        
//        if ([NNAnalyticsController postUserDataToServer:[NNAnalyticsController formatUserDataForUpload:playerDetails]
//                                          usingUsername:firstName
//                                               password:lastInitial]) {
            [self addPlayer:playerDetails];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to connect to network. Please check connection and try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alert show];
//            return;
//        }
    }
}

- (IBAction)tappedNewPlayer:(id)sender {
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        [UIView animateWithDuration:0.25 animations:^{
            self.NewPlayerView.center = CGPointMake(512, 196);
        }];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            self.NewPlayerView.center = CGPointMake(240, 160);
        }];
    }
    [self.firstNameTxt becomeFirstResponder];
}

- (IBAction)tappedStart:(id)sender {
    if ([self.existingUserPicker numberOfRowsInComponent:0]>0) {
        NSString *selectedPlayer = playerList[[self.existingUserPicker selectedRowInComponent:0]];
        [self playerConfirmation:selectedPlayer];
    }
    else{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"It doesn't look like any players have been created. Tap New Player to get started." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    return;
}

- (IBAction)tappedExitNewPlayerCreation:(id)sender {
    [self dismissNewPlayerView];
}

# pragma mark -
# pragma mark Supporting Methods
- (void)addPlayer:(NSDictionary*)playerDetails{
    
    // Add the name to the picker view and refresh the picker
    NSString *newPlayerName =[NSString stringWithFormat:@"%@ %@",[playerDetails objectForKey:@"first_name"],[playerDetails objectForKey:@"last_name"]];
    [playerList addObject:newPlayerName];
    [self.existingUserPicker reloadAllComponents];
    
    // Add the name to the existingPlayers mutable array and write to file
    [existingPlayers addObject:playerDetails];
    [existingPlayers writeToFile:filePath atomically:YES];
    
    // Clear textfields, dismiss newPlayerView, start the game
    [self dismissNewPlayerView];
    [self playerConfirmation:newPlayerName];
}

- (void)dismissNewPlayerView{
    // Dismiss the newPlayerView
    [self.view endEditing:YES];
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        [UIView animateWithDuration:0.25 animations:^{
            self.NewPlayerView.center = CGPointMake(512, 924);
        }];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            self.exitNewPlayerSetup.center= CGPointMake(417, 20);
            self.NewPlayerView.center = CGPointMake(240, 460);
        }];
    }

    // Clear all text fields on newPlayerView
    self.firstNameTxt.text = @"";
    self.lastNameTxt.text = @"";
    self.ageTxt.text = @"";
    self.raceTxt.text = @"";
    self.nativeLanguageTxt.text = @"";
}

- (NSString*)dateCreated{
    // Return the current date and time
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yy_hh.mm.ss_a"];
    NSString *timeCreated = [dateFormat stringFromDate:[NSDate date]];
    return timeCreated;
}

- (void)playerConfirmation:(NSString*)selectedPlayer{
    UIAlertView *confirmation = [[UIAlertView alloc]initWithTitle:@"Just making sure" message:[NSString stringWithFormat:@"Are you really %@?",selectedPlayer] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No",nil];
    confirmation.tag = 1;
    [confirmation show];
}

#pragma mark -
#pragma mark Data Validation Methods
-(void)validationError:(NSString*)invalidField{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Please enter a valid %@.",invalidField] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    return;
}

-(BOOL)validData:(NSString*)string field:(newPlayerFields)field{
    // TODO: Add criteria for validation based on API guidelines
//    NSUInteger maxNameLength = 30;
//    
//    switch (field) {
//        case NPFirstName:
//            if (string.length <= maxNameLength) {
//                return YES;
//            }
//            return NO;
//            break;
//        case NPLastName:
//            if (string.length <= maxNameLength){
//                ret
//            }
//            break;
//        case NPAge:
//            <#statements#>
//            break;
//        case NPRace:
//            <#statements#>
//            break;
//        case NPNativeLang:
//            <#statements#>
//            break;
//        default:
//            break;
//    }
    return YES;
}

#pragma mark -
#pragma mark PickerViewDelegate and Datasource Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return playerList.count
    ;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return playerList[row];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            //TODO: Add code to enter game here and set global user and session variables
            NSLog(@"Entered Game");
        }
        else{
            NSLog(@"Return to login");
            return;
        }
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.firstNameTxt) {
        [self.lastNameTxt becomeFirstResponder];
    }
    else if (textField == self.lastNameTxt){
        [self.ageTxt becomeFirstResponder];
    }
    else if (textField == self.ageTxt){
        [self.raceTxt becomeFirstResponder];
    }
    else if (textField == self.raceTxt){
        [self.nativeLanguageTxt becomeFirstResponder];
    }
    else{
        [self tappedCreateNewPlayer:self];
    }

    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        return;
    }
    else{
        CGPoint centerStartPoint = CGPointMake(240, 160);
        CGPoint exitBtnStartPoint = CGPointMake(417, 20);
        CGFloat offsetDistance = 33;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            if (textField == self.firstNameTxt) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.NewPlayerView.center = CGPointMake(centerStartPoint.x, centerStartPoint.y);
                    self.exitNewPlayerSetup.center = CGPointMake(exitBtnStartPoint.x, exitBtnStartPoint.y);
                }];
            }
            else if (textField == self.lastNameTxt) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.NewPlayerView.center = CGPointMake(centerStartPoint.x, centerStartPoint.y-offsetDistance);
                    self.exitNewPlayerSetup.center = CGPointMake(exitBtnStartPoint.x, exitBtnStartPoint.y+offsetDistance);
                }];
            }
            else if (textField == self.ageTxt) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.NewPlayerView.center = CGPointMake(centerStartPoint.x, centerStartPoint.y-offsetDistance*2);
                    self.exitNewPlayerSetup.center = CGPointMake(exitBtnStartPoint.x, exitBtnStartPoint.y+offsetDistance*2);
                }];
            }
            else if (textField == self.raceTxt){
                [UIView animateWithDuration:0.25 animations:^{
                    self.NewPlayerView.center = CGPointMake(centerStartPoint.x, centerStartPoint.y-offsetDistance*3);
                    self.exitNewPlayerSetup.center = CGPointMake(exitBtnStartPoint.x, exitBtnStartPoint.y+offsetDistance*3);
                }];
            }
            else if (textField == self.nativeLanguageTxt){
                [UIView animateWithDuration:0.25 animations:^{
                    self.NewPlayerView.center = CGPointMake(centerStartPoint.x, centerStartPoint.y-offsetDistance*4);
                    self.exitNewPlayerSetup.center = CGPointMake(exitBtnStartPoint.x, exitBtnStartPoint.y+offsetDistance*4);
                }];
            }
            else if (textField == self.raceTxt){
                [UIView animateWithDuration:0.25 animations:^{
                    self.NewPlayerView.center = CGPointMake(centerStartPoint.x, centerStartPoint.y-offsetDistance*5);
                    self.exitNewPlayerSetup.center = CGPointMake(exitBtnStartPoint.x, exitBtnStartPoint.y+offsetDistance*5);
                }];
            }
        }
    }
}
@end
