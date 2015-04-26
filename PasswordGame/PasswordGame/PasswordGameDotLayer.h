//
//  PasswordGameDotLayer.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-17.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PasswordGameView.h"

@class PasswordGameView;

@interface PasswordGameDotLayer : CALayer

@property (weak) PasswordGameView* gameView;
@property Dot* dot;
@property float centerX;
@property float centerY;
@property BOOL selected;
@property BOOL enabled;
@property BOOL playing;
@property BOOL hinted;


-(id) initWithDot:(Dot*)dot
dotSizeScaleFactor:(float)dotSizeScaleFactor
  dotSpaceFactor0:(float)d0
  dotSpaceFactor1:(float)d1
imageTypeIndicator:(int)imageType;

-(BOOL) hasSameCoordsAs:(Dot*)dot;
-(void) setVisuals;

@end
