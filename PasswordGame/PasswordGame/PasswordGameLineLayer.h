//
//  PasswordGameLineLayer.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-17.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PasswordGameView.h"
#import "Line.h"

@class PasswordGameView;

@interface PasswordGameLineLayer : CAShapeLayer

@property (weak) PasswordGameView* gameView;
@property Line* line;
@property BOOL hinted;

-(id) initWithFromDot:(Dot*)fromDot
                toDot:(Dot*)toDot
    dotSpacingFactor0:(float)dotSpacingFactor0
    dotSpacingFactor1:(float)dotSpacingFactor1;

@end

