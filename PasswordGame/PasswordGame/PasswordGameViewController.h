//
//  PasswordGameViewController.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-10.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordGameView.h"
#import "PasswordsSingleton.h"
#import "SavedPasswords.h"
#import "Game.h"
#import "PasswordGameView.h"
#import "SetUpViewController.h"
#import "PasswordGameDotLayer.h"
#import "PasswordGameLineLayer.h"


@interface PasswordGameViewController : UIViewController

@property int imageTypeIndicator;
@property BOOL playing;
@property Game* game;
@property SavedPasswords* savedPasswords;
@property PasswordGameView* gameView;
@property (weak, nonatomic) IBOutlet UIButton *loadPasswordsButton;
@property (weak, nonatomic) IBOutlet UIButton *hintButton;

@end
