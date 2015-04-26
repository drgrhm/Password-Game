//
//  SetUpViewController.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-10.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "SetUpViewController.h"
#import "PasswordGameViewController.h"


@interface SetUpViewController ()
@end


@implementation SetUpViewController
{
    ToastView* toast;
    float toastDuration;
}


- (void)viewDidLoad
{
    toastDuration = 7.0;
    [super viewDidLoad];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoButton
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:7.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoButton
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-7.0]];
    [_backgroundView removeFromSuperview];
    _backgroundView = [[BackgroundView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_backgroundView atIndex:0];
    [self loadPasswords];
    [self showSavedPasswordsToast];
}


- (IBAction)difficultyLevelChanged:(id)sender
{
    [self showSavedPasswordsToast];
}


- (void)showSavedPasswordsToast
{
    NSString* message;
    if (_difficultyLevelSegmentedControl.selectedSegmentIndex == 0)
    {
        if (_savedPasswords.saved3DPasswords.count == 0)
        {
            message = @"No saved Easy Passwords.";
        }
        if (_savedPasswords.saved3DPasswords.count == 1)
        {
            message = @"1 saved Easy Password.";
        }
        if (_savedPasswords.saved3DPasswords.count >= 2)
        {
            message = [[NSString alloc] initWithFormat:@"%d saved Easy Passwords." , (uint32_t)_savedPasswords.saved3DPasswords.count];
        }
    }
    if (_difficultyLevelSegmentedControl.selectedSegmentIndex == 1)
    {
        if (_savedPasswords.saved4DPasswords.count == 0)
        {
            message = @"No saved Moderate Passwords.";
        }
        if (_savedPasswords.saved4DPasswords.count == 1)
        {
            message = @"1 saved Moderate Password.";
        }
        if (_savedPasswords.saved4DPasswords.count >= 2)
        {
            message = [[NSString alloc] initWithFormat:@"%d saved Moderate Passwords." , (uint32_t)_savedPasswords.saved4DPasswords.count];
        }
    }
    if (_difficultyLevelSegmentedControl.selectedSegmentIndex == 2)
    {
        if (_savedPasswords.saved5DPasswords.count == 0)
        {
            message = @"No saved Hard Passwords.";
        }
        if (_savedPasswords.saved5DPasswords.count == 1)
        {
            message = @"1 saved Hard Password.";
        }
        if (_savedPasswords.saved5DPasswords.count >= 2)
        {
            message = [[NSString alloc] initWithFormat:@"%d saved Hard Passwords." , (uint32_t)_savedPasswords.saved5DPasswords.count];
        }
    }
    [toast removeFromSuperview];
    toast = [ToastView showToastInParentView:self.view withText:message withDuaration:toastDuration];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"setupToPlaySegue"])
    {
        PasswordGameViewController *destination = (PasswordGameViewController *)segue.destinationViewController;
        destination.imageTypeIndicator = (int)_colorSegmentedControl.selectedSegmentIndex;
        destination.game = [[Game alloc] initWithDimension:(int)_difficultyLevelSegmentedControl.selectedSegmentIndex + 3
                                           correctPassword:[[Password alloc] init]
                                          selectedPassword:[[Password alloc] init]
                                                hintedDots:[[NSMutableArray alloc] initWithCapacity:26]
                                               hintedLines:[[NSMutableArray alloc] initWithCapacity:26]];
        destination.savedPasswords = _savedPasswords;
    }
}


- (IBAction)unwindToSetUpFromPlay:(UIStoryboardSegue *)segue
{
    PasswordGameViewController* source = (PasswordGameViewController*)segue.sourceViewController;
    source.playing = false;
    _savedPasswords = source.savedPasswords;
    [self showSavedPasswordsToast];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self loadPasswords];
    }
    return self;
}


- (void)loadPasswords
{
    NSString *filePath = [self pathForPasswords];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        _savedPasswords = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    else
    {
        _savedPasswords = [[SavedPasswords alloc] init];
        [self savePasswords];
    }
}


- (void)savePasswords
{
    NSString *filePath = [self pathForPasswords];
    [NSKeyedArchiver archiveRootObject:_savedPasswords toFile:filePath];
}


- (NSString *)pathForPasswords
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documents = [directories lastObject];
    return [documents stringByAppendingPathComponent:@"savedPasswords.plist"];
}


- (IBAction)showInfo:(id)sender
{
    NSString* message = @"Made by Devon for Hana.\r\n\r\nwww.hanaspasswordgame.wordpress.com\r\n\r\nIcons made by Freepik, Icons8, and Icomoon from www.flaticon.com are licensed under CC BY 3.0";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Info"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
