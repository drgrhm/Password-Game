//
//  SetUpViewController.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-10.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedPasswords.h"
#import "BackgroundView.h"
#import "ToastView.h"

@interface SetUpViewController : UIViewController

@property SavedPasswords* savedPasswords;
@property (nonatomic, strong) BackgroundView* backgroundView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyLevelSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end
