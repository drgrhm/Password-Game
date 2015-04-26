//
//  PasswordGameLineLayer.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-17.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "PasswordGameLineLayer.h"

@implementation PasswordGameLineLayer


-(id) initWithFromDot:(Dot*)fromDot
                toDot:(Dot*)toDot
    dotSpacingFactor0:(float)dotSpacingFactor0
    dotSpacingFactor1:(float)dotSpacingFactor1
{
    self = [super init];
    if (self)
    {
        _line = [[Line alloc] initWithFromDot:fromDot toDot:toDot];
    }
    return self;
}


-(void) display
{
    [super display];
    self.fillColor = [[UIColor clearColor] CGColor];
    if (_hinted)
    {
        self.strokeColor = [[UIColor grayColor] CGColor];
    }
    else
    {
        self.strokeColor = [[UIColor blackColor] CGColor];
    }
}







@end
