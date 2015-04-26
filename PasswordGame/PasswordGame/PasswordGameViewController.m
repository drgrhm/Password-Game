//
//  PasswordGameViewController.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-10.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "PasswordGameViewController.h"

@interface PasswordGameViewController ()

@end


@implementation PasswordGameViewController
{
    float lineSize;
    float dotSpacingFactor0;
    float dotSpacingFactor1;
    float gameViewScaleFactor;
    float dotSizeScaleFactor;
    float gameSize;
    CGRect gameFrame;
    BackgroundView* backgroundView;
    BOOL saving;
    BOOL messageShown;
    NSMutableArray* gameWonImageViews;
    int numberOfWinningSequenceImages;
    float winningSequenceDuration;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [backgroundView removeFromSuperview];
    backgroundView = [[BackgroundView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:backgroundView atIndex:0];
    
    //Set game visual elements:
    gameSize = MIN(self.view.bounds.size.height, self.view.bounds.size.width);
    gameViewScaleFactor =  0.91; // in (0,1]
    dotSizeScaleFactor = 0.41; // in (0,1]
    numberOfWinningSequenceImages = 500;
    winningSequenceDuration = 0.15;
    lineSize = 41.0 * gameViewScaleFactor * dotSizeScaleFactor / _game.dimension * MIN(self.view.bounds.size.height, self.view.bounds.size.width) / MAX(self.view.bounds.size.height, self.view.bounds.size.width);
    dotSpacingFactor0 = (gameSize * dotSizeScaleFactor * gameViewScaleFactor) / (2 * _game.dimension);
    dotSpacingFactor1 = (gameSize * gameViewScaleFactor) / _game.dimension;
    gameFrame = CGRectMake(0.0, 0.0, gameSize * gameViewScaleFactor, gameSize * gameViewScaleFactor);
    _gameView = [[PasswordGameView alloc] initWithFrame:gameFrame
                                                   game:_game
                                     imageTypeIndicator:_imageTypeIndicator
                                     dotSizeScaleFactor:dotSizeScaleFactor
                                    gameViewScaleFactor:gameViewScaleFactor
                                      dotSpacingFactor0:dotSpacingFactor0
                                      dotSpacingFactor1:dotSpacingFactor1
                                               lineSize:lineSize];
    
    [_gameView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_gameView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_gameView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_gameView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_gameView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:gameSize * gameViewScaleFactor]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_gameView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:gameSize * gameViewScaleFactor]];
    
    [_gameView addTarget:self
                  action:@selector(gameViewChanged:)
        forControlEvents:UIControlEventValueChanged];
    gameWonImageViews = [[NSMutableArray alloc] init];
    
    if (!_playing && !messageShown)
    {
        [self showInitialMessage];
    }
    [self setLoadPasswordsButton];
    _hintButton.enabled = false;
}


- (void)showInitialMessage
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* setAction = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {[self doSetPassword:action];}];
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {[self doSavePassword:action];}];
    UIAlertAction* randomAction = [UIAlertAction actionWithTitle:@"Play Random" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {[self doPlayRandomPassword:action];}];
    [alert addAction:setAction];
    [alert addAction:saveAction];
    [alert addAction:randomAction];
    [self presentViewController:alert animated:YES completion:nil];
    messageShown = true;
}


- (void)doSetPassword:(UIAlertAction*)action
{
    _playing = false;
    saving = false;
}


- (void)doSavePassword:(UIAlertAction*)action
{
    _playing = false;
    saving = true;
}


- (void)doPlayRandomPassword:(UIAlertAction*)action
{
    if (_game.dimension == 3)
    {
        if (_savedPasswords.saved3DPasswords.count > 0)
        {
            int r = arc4random_uniform((uint32_t)_savedPasswords.saved3DPasswords.count);
            [_game.correctPassword copyPassword:[_savedPasswords.saved3DPasswords objectAtIndex:r]];
            [_gameView setUpCorrectPasswordLineLayers];
            _playing = true;
            _gameView.playing = true;
            _gameView.enabled = true;
            _hintButton.enabled = true;
            for (PasswordGameDotLayer* dotLayer in _gameView.dotLayers)
            {
                dotLayer.playing = true;
                [dotLayer setNeedsDisplay];
            }
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:@"No Passwords saved."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:^{[NSThread sleepForTimeInterval:0.6f];}];
            [alert dismissViewControllerAnimated:YES completion:^{[self showInitialMessage];}];
            messageShown = false;
        }
    }
    if (_game.dimension == 4)
    {
        if (_savedPasswords.saved4DPasswords.count > 0)
        {
            int r = arc4random_uniform((uint32_t)_savedPasswords.saved4DPasswords.count);
            [_game.correctPassword copyPassword:[_savedPasswords.saved4DPasswords objectAtIndex:r]];
            [_gameView setUpCorrectPasswordLineLayers];
            _playing = true;
            _gameView.playing = true;
            _gameView.enabled = true;
            _hintButton.enabled = true;
            for (PasswordGameDotLayer* dotLayer in _gameView.dotLayers)
            {
                dotLayer.playing = true;
                [dotLayer setNeedsDisplay];
            }
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:@"No Passwords saved."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:^{[NSThread sleepForTimeInterval:0.6f];}];
            [alert dismissViewControllerAnimated:YES completion:^{[self showInitialMessage];}];
            messageShown = false;
        }
    }
    if (_game.dimension == 5)
    {
        if (_savedPasswords.saved5DPasswords.count > 0)
        {
            int r = arc4random_uniform((uint32_t)_savedPasswords.saved5DPasswords.count);
            [_game.correctPassword copyPassword:[_savedPasswords.saved5DPasswords objectAtIndex:r]];
            [_gameView setUpCorrectPasswordLineLayers];
            _playing = true;
            _gameView.playing = true;
            _gameView.enabled = true;
            _hintButton.enabled = true;
            for (PasswordGameDotLayer* dotLayer in _gameView.dotLayers)
            {
                dotLayer.playing = true;
                [dotLayer setNeedsDisplay];
            }
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:@"No Passwords saved."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:^{[NSThread sleepForTimeInterval:0.6f];}];
            [alert dismissViewControllerAnimated:YES completion:^{[self showInitialMessage];}];
            messageShown = false;
        }
    }
}


- (void)gameViewChanged:(id)control
{
    if (_playing)
    {
        if (_game.won)
        {
            [self wonGameHelper];
        }
        else
        {
            [self playingGameHelper];
        }
    }
    else
    {
        if (_game.selectedPassword.dots.count > 3)
        {
            if (saving)
            {
                [self saveGameHelper];
            }
            else
            {
                [self setGameHelper];
            }
        }
        else
        {
            [self passwordTooShortHelper];
        }
    }
}


- (void)wonGameHelper
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You Won!"
                                                                   message:@"Play again?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {[self doWonYesPlayAgain:action];}];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {}];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
    for (PasswordGameDotLayer* dotLayer in _gameView.dotLayers)
    {
        [dotLayer setNeedsDisplay];
    }
    _gameView.enabled = false;
    [self showWinningSequence];
    _hintButton.enabled = false;
}


- (void)playingGameHelper
{
    [self clearLayers];
    [_game.selectedPassword clear];
    _gameView.enabled = true;
}


- (void)saveGameHelper
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Save Password?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {[self doYesSave:action];}];
    UIAlertAction* setAndSaveAction = [UIAlertAction actionWithTitle:@"Save and Set" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {[self doSetAndSavePassword:action];}];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {[self doNoSave:action];}];
    [alert addAction:yesAction];
    [alert addAction:setAndSaveAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)setGameHelper
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Set Password?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* setAsCurrentAction = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {[self doSetPasswordAsCurrent:action];}];
    UIAlertAction* setAndSaveAction = [UIAlertAction actionWithTitle:@"Set and Save" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {[self doSetAndSavePassword:action];}];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {[self doCancelPassword:action];}];
    [alert addAction:setAsCurrentAction];
    [alert addAction:setAndSaveAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)passwordTooShortHelper
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Must be at least 4 dots."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{[NSThread sleepForTimeInterval:0.6f];}];
    [alert dismissViewControllerAnimated:YES completion:nil];
    [_game.selectedPassword clear];
    [self clearLayers];
    _gameView.enabled = true;
}


- (void)doWonYesPlayAgain:(UIAlertAction*)action
{
    [self resetView];
}


- (void)doYesSave:(UIAlertAction*)action
{
    /*
     //For getting password strings from the console to easily make default passwords:
     ////........
     NSString* passwordString = @"@\"(";
     NSString* appender;
     NSInteger i = (NSInteger)_game.selectedPassword.dots.count;
     for (Dot* dot in _game.selectedPassword.dots)
     {
     appender = [[NSString alloc] initWithFormat:@"%i,%i)", dot.x, dot.y];
     passwordString = [passwordString stringByAppendingString:appender];
     if (i > 1)
     {
     appender = @"(";
     }
     else
     {
     appender = @";\",";
     }
     passwordString = [passwordString stringByAppendingString:appender];
     i--;
     }
     NSLog(passwordString);
     ////......
     */
    
    [self saveCurrentPassword];
    [self setLoadPasswordsButton];
    for (PasswordGameDotLayer* dotLayer in _gameView.dotLayers)
    {
        dotLayer.playing = false;
    }
    [self clearLayers];
    [_game.selectedPassword clear];
    _gameView.enabled = true;
    [self showInitialMessage];
}


- (void)doSetAndSavePassword:(UIAlertAction*)action
{
    [self saveCurrentPassword];
    [self doSetPasswordAsCurrent:action];
    [self setLoadPasswordsButton];
}


- (void)doNoSave:(UIAlertAction*)action
{
    [self clearLayers];
    [_game.selectedPassword clear];
    _gameView.enabled = true;
    [self showInitialMessage];
}


- (void)doSetPasswordAsCurrent:(UIAlertAction*)action
{
    for (PasswordGameDotLayer* dotLayer in _gameView.dotLayers)
    {
        dotLayer.playing = true;
    }
    [self clearLayers];
    [_game.correctPassword setTo:_game.selectedPassword];
    [_gameView setUpCorrectPasswordLineLayers];
    [_game.selectedPassword clear];
    _playing = true;
    _gameView.playing = true;
    _gameView.enabled = true;
    _hintButton.enabled = true;
}


- (void)doCancelPassword:(UIAlertAction*)action
{
    [self clearLayers];
    [_game.selectedPassword clear];
    _gameView.enabled = true;
    [self showInitialMessage];
}


- (void)resetView
{
    [_game.correctPassword clear];
    [_game.selectedPassword clear];
    [_game.hintedDots removeAllObjects];
    [_game.hintedLines removeAllObjects];
    _game.won = false;
    _playing = false;
    messageShown = false;
    _gameView.layer.sublayers = nil;
    [_gameView removeFromSuperview];
    for (UIImageView* imageView in gameWonImageViews)
    {
        [imageView removeFromSuperview];
    }
    [self viewDidLoad];
}


- (void)saveCurrentPassword
{
    Password* password = [[Password alloc] initWithCopyingDots:_game.selectedPassword.dots];
    if (_game.dimension == 3)
    {
        [_savedPasswords.saved3DPasswords addObject:password];
    }
    if (_game.dimension == 4)
    {
        [_savedPasswords.saved4DPasswords addObject:password];
    }
    if (_game.dimension == 5)
    {
        [_savedPasswords.saved5DPasswords addObject:password];
    }
    [self savePasswordsToFile];
}


- (void)savePasswordsToFile
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


- (void)showWinningSequence
{
    float delay;
    float x;
    float y;
    int rx1;
    int rx2;
    int ry1;
    int ry2;
    UIImage* image;
    UIImageView* imageView;
    for (int i = 0; i < numberOfWinningSequenceImages; i++)
    {
        delay = (float)i * winningSequenceDuration + 0.5;
        rx1 = arc4random_uniform(1000);
        rx2 = arc4random_uniform(1000);
        ry1 = arc4random_uniform(1000);
        ry2 = arc4random_uniform(1000);
        if (rx1 < rx2)
        {
            x = MAX(self.view.frame.size.width, self.view.frame.size.height) * rx1 / rx2;
        }
        else
        {
            x = MAX(self.view.frame.size.width, self.view.frame.size.height) * rx2 / rx1;
        }
        if (ry1 < ry2)
        {
            y = MAX(self.view.frame.size.width, self.view.frame.size.height) * ry1 / ry2;
        }
        else
        {
            y = MAX(self.view.frame.size.width, self.view.frame.size.height) * ry2 / ry1;
        }
        if (_imageTypeIndicator == 0)
        {
            image = [UIImage imageNamed:@"FlowerPink"];
        }
        if (_imageTypeIndicator == 1)
        {
            image = [UIImage imageNamed:@"LadybugRed"];
        }
        if (_imageTypeIndicator == 2)
        {
            image = [UIImage imageNamed:@"SkullWhite"];
        }
        imageView = [[UIImageView alloc] initWithImage:image];
        [gameWonImageViews addObject:imageView];
        float frameSize = (MIN(self.view.frame.size.height, self.view.frame.size.width) * dotSizeScaleFactor * gameViewScaleFactor) / _game.dimension;
        imageView.frame = CGRectMake(x, y, frameSize, frameSize);
        [imageView setAlpha:0.0];
        [self.view insertSubview:imageView atIndex:1];
        [UIImageView animateWithDuration:winningSequenceDuration
                                   delay:delay
                                 options: UIViewAnimationOptionCurveEaseOut & UIViewAnimationOptionTransitionCurlUp
                              animations:^{[imageView setAlpha:1.0];}
                              completion:^(BOOL finished){}];
    }
}


- (void)clearLayers
{
    for (PasswordGameDotLayer* dotLayer in _gameView.dotLayers)
    {
        dotLayer.selected = false;
        dotLayer.sublayers = nil;
        [dotLayer setNeedsDisplay];
    }
    for (PasswordGameLineLayer* lineLayer in _gameView.lineLayers)
    {
        lineLayer.sublayers = nil;
        [lineLayer removeFromSuperlayer];
    }
}


- (IBAction)giveHint:(id)sender
{
    if (_playing && _game.correctPassword.dots.count > 0)
    {
        int r;
        if (_game.hintedDots.count < _game.correctPassword.dots.count)
        {
            NSMutableArray* notHintedDots = [[NSMutableArray alloc] initWithCapacity:_game.correctPassword.dots.count];
            [notHintedDots addObjectsFromArray:_game.correctPassword.dots];
            [notHintedDots removeObjectsInArray:_game.hintedDots];
            r = arc4random_uniform((uint32_t)notHintedDots.count);
            [_game.hintedDots addObject:[notHintedDots objectAtIndex:r]];
            for (PasswordGameDotLayer* dotLayer in _gameView.dotLayers)
            {
                if ([dotLayer.dot isEqual:[notHintedDots objectAtIndex:r]])
                {
                    dotLayer.hinted = true;
                    [dotLayer setNeedsDisplay];
                    break;
                }
            }
        }
        else
        {
            if (_gameView.hintedLineLayers.count < _gameView.correctPasswordLineLayers.count)
            {
                NSMutableArray* notHintedLineLayers = [[NSMutableArray alloc] initWithCapacity:_gameView.correctPasswordLineLayers.count];
                [notHintedLineLayers addObjectsFromArray:_gameView.correctPasswordLineLayers];
                [notHintedLineLayers removeObjectsInArray:_gameView.hintedLineLayers];
                r = arc4random_uniform((uint32_t)notHintedLineLayers.count);
                [_gameView.hintedLineLayers addObject:[notHintedLineLayers objectAtIndex:r]];
                ((PasswordGameLineLayer*)[notHintedLineLayers objectAtIndex:r]).hinted = true;
                [(PasswordGameLineLayer*)[notHintedLineLayers objectAtIndex:r] setNeedsDisplay];
            }
        }
    }
}


- (IBAction)loadDefaultPasswordsAction:(id)sender
{
    if (_game.dimension == 3)
    {
        _savedPasswords.saved3DPasswords = [self loadDefault3DPasswords:sender];
    }
    if (_game.dimension == 4)
    {
        _savedPasswords.saved4DPasswords = [self loadDefault4DPasswords:sender];
    }
    if (_game.dimension == 5)
    {
        _savedPasswords.saved5DPasswords = [self loadDefault5DPasswords:sender];
    }
    [self savePasswordsToFile];
    [self setLoadPasswordsButton];
}


- (NSMutableArray*)loadDefault3DPasswords:(id)sender
{
    NSMutableArray* passwords = [[NSMutableArray alloc] init];
    NSMutableArray* passwordStrings = [[NSMutableArray alloc] initWithObjects:
                                       @"(0,0)(0,1)(0,2)(1,2)(2,2);",
                                       @"(0,0)(1,0)(2,0)(2,1)(2,2);",
                                       @"(0,2)(1,1)(2,0)(2,1);",
                                       @"(2,2)(1,1)(0,0)(0,1);",
                                       @"(0,0)(1,0)(2,0)(1,1)(1,2);",
                                       @"(2,0)(1,0)(0,0)(1,1)(1,2);",
                                       @"(0,0)(1,1)(2,2)(2,1)(2,0)(1,0);",
                                       @"(2,0)(1,1)(0,2)(0,1)(0,0)(1,0);",
                                       @"(0,0)(1,0)(2,0)(1,1)(2,2)(1,2)(0,2);",
                                       @"(1,0)(2,2)(0,1)(2,0)(1,2)(0,0)(2,1)(0,2);",
                                       @"(2,2)(1,2)(0,2)(1,1)(2,0);",
                                       @"(0,2)(1,2)(2,2)(1,1)(0,0);",
                                       @"(0,0)(1,1)(2,2)(1,2)(0,2)(2,0);",
                                       @"(2,0)(2,1)(2,2)(1,2)(0,2)(0,1)(0,0);",
                                       @"(1,1)(0,2)(0,1)(2,0)(1,2);",
                                       @"(1,1)(2,2)(2,1)(0,0)(1,0)(2,0);",
                                       @"(0,0)(0,1)(0,2)(1,1)(2,2)(2,1)(2,0);",
                                       @"(1,0)(0,2)(1,2)(2,2)(1,1);",
                                       @"(2,1)(0,2)(1,0)(2,0);",
                                       @"(0,0)(1,0)(1,1)(1,2)(0,1)(2,1);",
                                       @"(2,0)(1,1)(0,2)(1,2)(0,1)(2,1)(1,0);",
                                       @"(2,1)(1,1)(0,2)(0,1)(0,0)(2,2);",
                                       @"(1,2)(2,1)(1,0)(1,1)(2,2)(0,2)(2,0)(0,0)(0,1);",
                                       nil];
    Password* password;
    for (NSString* string in passwordStrings)
    {
        password = [[Password alloc] initWithString:string];
        [passwords addObject:password];
    }
    return passwords;
}


- (NSMutableArray*)loadDefault4DPasswords:(id)sender
{
    NSMutableArray* passwords = [[NSMutableArray alloc] init];
    NSMutableArray* passwordStrings = [[NSMutableArray alloc] initWithObjects:
                                       @"(0,0)(1,0)(2,0)(3,0)(3,1)(3,2)(3,3);",
                                       @"(0,0)(0,1)(0,2)(0,3)(1,3)(2,3)(3,3);",
                                       @"(0,3)(1,2)(2,1)(3,0)(3,1)(3,2)(3,3);",
                                       @"(3,3)(2,2)(1,1)(0,0)(0,1)(0,2)(0,3);",
                                       @"(1,2)(2,2)(2,1)(1,1);",
                                       @"(0,3)(1,3)(2,3)(3,3)(3,2)(2,2)(1,2)(0,2)(0,1)(1,1)(2,1)(3,1)(3,0)(2,0)(1,0)(0,0);",
                                       @"(0,0)(1,1)(2,2)(3,3)(2,3)(1,3)(0,3)(1,2)(2,1)(3,0);",
                                       @"(3,2)(2,2)(1,2)(0,2);",
                                       @"(1,0)(2,1)(3,2)(2,3)(1,2)(0,1);",
                                       @"(0,0)(1,1)(2,2)(3,2)(2,1)(1,0);",
                                       @"(3,0)(2,1)(2,2)(3,2)(3,1);",
                                       @"(0,1)(1,2)(2,3)(3,2)(3,1)(2,0)(1,1)(2,2)(2,1);",
                                       @"(0,0)(1,0)(2,0)(3,0)(3,1)(3,2)(3,3)(2,3)(1,3)(0,3)(0,2)(0,1)(1,1)(2,1)(2,2)(1,2);",
                                       @"(0,1)(1,1)(2,1)(3,1)(2,2)(1,3)(1,2)(1,0);",
                                       @"(3,0)(2,1)(1,2)(2,2)(1,1)(0,0)(0,1)(0,2)(3,2)(3,1);",
                                       @"(1,1)(1,2)(1,3)(2,3)(0,2)(2,1)(3,0)(2,0)(0,1)(2,2);",
                                       @"(3,3)(2,2)(1,1)(1,2)(2,1)(0,1)(0,2)(0,3)(3,0)(2,0)(1,0)(0,0);",
                                       nil];
    Password* password;
    for (NSString* string in passwordStrings)
    {
        password = [[Password alloc] initWithString:string];
        [passwords addObject:password];
    }
    return passwords;
}


- (NSMutableArray*)loadDefault5DPasswords:(id)sender
{
    NSMutableArray* passwords = [[NSMutableArray alloc] init];
    NSMutableArray* passwordStrings = [[NSMutableArray alloc] initWithObjects:
                                       @"(0,0)(1,0)(2,0)(3,0)(4,0)(4,1)(4,2)(4,3)(4,4);",
                                       @"(0,0)(0,1)(0,2)(0,3)(0,4)(1,4)(2,4)(3,4)(4,4);",
                                       @"(0,0)(1,1)(2,2)(3,3)(4,4)(3,4)(2,4)(1,4)(0,4)(1,3)(3,1)(4,0);",
                                       @"(1,1)(1,2)(1,3)(2,3)(3,3)(3,2)(3,1);",
                                       @"(0,2)(1,3)(2,4)(3,3)(4,2)(3,1)(2,0)(1,1);",
                                       @"(2,2)(3,2)(4,2)(4,3)(4,4)(3,4)(2,4)(1,4)(0,4)(0,3)(0,2)(1,2)(1,3)(2,3)(3,3);",
                                       @"(0,0)(0,1)(0,2)(1,2)(1,1)(1,0)(2,0)(3,0)(3,1)(3,2)(4,2)(4,1)(4,0);",
                                       @"(4,0)(3,1)(2,2)(3,3)(4,4)(3,4)(2,4)(1,4)(0,4)(1,3);",
                                       @"(0,0)(1,0)(2,0)(3,0)(4,0);",
                                       @"(0,4)(1,4)(1,3)(2,3)(2,2)(3,2)(3,1)(4,1)(4,0)(3,0)(2,0)(2,1)(1,1)(1,2)(0,2)(0,3);",
                                       @"(0,0)(1,0)(2,0)(3,0)(4,0)(4,1)(4,2)(4,3)(4,4)(3,4)(2,4)(1,4)(0,4)(0,3)(0,2)(0,1)(1,1)(2,1)(3,1)(3,2)(3,3)(2,3)(1,3)(1,2)(2,2);",
                                       @"(0,0)(1,1)(2,2)(2,1)(1,2)(3,2)(3,1)(3,0)(0,3)(1,3)(2,3)(3,3)(4,3)(4,2)(4,1)(4,0);",
                                       @"(3,4)(2,3)(2,2)(3,3)(1,3)(0,3)(1,2)(3,1)(4,3)(0,2)(3,2)(2,0)(1,1)(0,1)(1,0)(2,1);",
                                       nil];
    Password* password;
    for (NSString* string in passwordStrings)
    {
        password = [[Password alloc] initWithString:string];
        [passwords addObject:password];
    }
    return passwords;
}


- (IBAction)deleteAllAction:(id)sender
{
    if (_game.dimension == 3)
    {
        if (_savedPasswords.saved3DPasswords.count == 1)
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete All?"
                                                                           message:@"You have 1 saved Password. Are you sure you want to delete it?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self doClearAllYes:action];}];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (_savedPasswords.saved3DPasswords.count == 2)
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete All?"
                                                                           message:@"You have 2 saved Passwords. Are you sure you want to delete them both?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self doClearAllYes:action];}];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (_savedPasswords.saved3DPasswords.count > 2)
        {
            NSString* message = [[NSString alloc] initWithFormat:@"You have %d saved Passwords. Are you sure you want to delete them all?", (uint32_t)_savedPasswords.saved3DPasswords.count];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete All?"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self doClearAllYes:action];}];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
    if (_game.dimension == 4)
    {
        if (_savedPasswords.saved4DPasswords.count == 1)
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete All?"
                                                                           message:@"You have 1 saved Password. Are you sure you want to delete it?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self doClearAllYes:action];}];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (_savedPasswords.saved4DPasswords.count == 2)
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete All?"
                                                                           message:@"You have 2 saved Passwords. Are you sure you want to delete them both?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self doClearAllYes:action];}];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (_savedPasswords.saved4DPasswords.count > 2)
        {
            NSString* message = [[NSString alloc] initWithFormat:@"You have %d saved Passwords. Are you sure you want to delete them all?", (uint32_t)_savedPasswords.saved4DPasswords.count];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete All?"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self doClearAllYes:action];}];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    if (_game.dimension == 5)
    {
        if (_savedPasswords.saved5DPasswords.count == 1)
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete All?"
                                                                           message:@"You have 1 saved Password. Are you sure you want to delete it?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self doClearAllYes:action];}];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (_savedPasswords.saved5DPasswords.count == 2)
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete All?"
                                                                           message:@"You have 2 saved Passwords. Are you sure you want to delete them both?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self doClearAllYes:action];}];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (_savedPasswords.saved5DPasswords.count > 2)
        {
            NSString* message = [[NSString alloc] initWithFormat:@"You have %d saved Passwords. Are you sure you want to delete them all?", (uint32_t)_savedPasswords.saved5DPasswords.count];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete All?"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self doClearAllYes:action];}];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
            [alert addAction:yesAction];
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}


- (void)doClearAllYes:(UIAlertAction*)action
{
    if (_game.dimension == 3)
    {
        [_savedPasswords.saved3DPasswords removeAllObjects];
    }
    if (_game.dimension == 4)
    {
        [_savedPasswords.saved4DPasswords removeAllObjects];
    }
    if (_game.dimension == 5)
    {
        [_savedPasswords.saved5DPasswords removeAllObjects];
    }
    [self savePasswordsToFile];
    [self setLoadPasswordsButton];
}


- (void)setLoadPasswordsButton
{
    [_loadPasswordsButton setTitle:@"Load starter \r\n passwords" forState:UIControlStateNormal];
    
    NSString* disabledString;
    
    if (_game.dimension == 3)
    {
        if (_savedPasswords.saved3DPasswords.count == 0)
        {
            _loadPasswordsButton.enabled = true;
        }
        else if (_savedPasswords.saved3DPasswords.count == 1)
        {
            _loadPasswordsButton.enabled = false;
            disabledString = @" 1 saved \r\npassword";
        }
        else if (_savedPasswords.saved3DPasswords.count > 1)
        {
            _loadPasswordsButton.enabled = false;
            disabledString = [[NSString alloc] initWithFormat:@"  %i saved \r\npasswords", (u_int32_t)_savedPasswords.saved3DPasswords.count];
        }
    }
    if (_game.dimension == 4)
    {
        if (_savedPasswords.saved4DPasswords.count == 0)
        {
            _loadPasswordsButton.enabled = true;
        }
        else if (_savedPasswords.saved4DPasswords.count == 1)
        {
            _loadPasswordsButton.enabled = false;
            disabledString = @" 1 saved \r\npassword";
        }
        else if (_savedPasswords.saved4DPasswords.count > 1)
        {
            _loadPasswordsButton.enabled = false;
            disabledString = [[NSString alloc] initWithFormat:@"%  i saved \r\npasswords", (uint32_t)_savedPasswords.saved4DPasswords.count];
        }
    }
    if (_game.dimension == 5)
    {
        if (_savedPasswords.saved5DPasswords.count == 0)
        {
            _loadPasswordsButton.enabled = true;
        }
        else if (_savedPasswords.saved5DPasswords.count == 1)
        {
            _loadPasswordsButton.enabled = false;
            disabledString = @" 1 saved \r\npassword";
        }
        else if (_savedPasswords.saved5DPasswords.count > 1)
        {
            _loadPasswordsButton.enabled = false;
            disabledString = [[NSString alloc] initWithFormat:@"%  i saved \r\npasswords", (uint32_t)_savedPasswords.saved5DPasswords.count];
        }
    }
    [_loadPasswordsButton setTitle:disabledString forState:UIControlStateDisabled];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end







