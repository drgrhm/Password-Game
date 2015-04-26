//
//  PasswrordGameView.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-10.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "Password.h"

IB_DESIGNABLE

@interface PasswordGameView : UIControl

@property Game* game;
@property NSMutableArray* dotLayers;
@property NSMutableArray* lineLayers;
@property NSMutableArray* hintedDotLayers;
@property NSMutableArray* hintedLineLayers;
@property NSMutableArray* correctPasswordLineLayers;
@property BOOL playing;
@property int imageTypeIndicator;

- (id)initWithFrame:(CGRect)frame
               game:(Game*)game
 imageTypeIndicator:(int)imageTypeIndicator
dotSizeScaleFactor:(float)dotSizeScaleFactor
gameViewScaleFactor:(float)gameViewScaleFactor
dotSpacingFactor0:(float)d0
dotSpacingFactor1:(float)d1
           lineSize:(float)lineSize;

- (void)setUpCorrectPasswordLineLayers;

@end
