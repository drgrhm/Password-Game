//
//  PasswordGameDotLayer.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-17.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "PasswordGameDotLayer.h"

@implementation PasswordGameDotLayer
{
    float dotSpaceFactor0;
    float dotSpaceFactor1;
    int imageTypeIndicator;
}


-(id) initWithDot:(Dot*)dot
dotSizeScaleFactor:(float)dotSizeScaleFactor
  dotSpaceFactor0:(float)d0
  dotSpaceFactor1:(float)d1
imageTypeIndicator:(int)imageType
{
    self = [super init];
    if (self)
    {
        _dot = dot;
        dotSpaceFactor0 = d0;
        dotSpaceFactor1 = d1;
        _centerX = _dot.x * dotSpaceFactor1 + dotSpaceFactor0 / dotSizeScaleFactor;
        _centerY = _dot.y * dotSpaceFactor1 + dotSpaceFactor0 / dotSizeScaleFactor;
        imageTypeIndicator = imageType;
    }
    return self;
}


-(void) display
{
    [super display];
    
    [self setMasksToBounds:YES];
    [self setBorderColor:[[UIColor clearColor] CGColor]];
    [self setBorderWidth:1.0];
    [self setCornerRadius:self.frame.size.width / 2.0];
    [self setBounds:CGRectMake(dotSpaceFactor1 * _dot.x, dotSpaceFactor1 * _dot.y, self.frame.size.width, self.frame.size.width)];
    [self setVisuals];
}


- (void)setVisuals
{
    float dotScaleFactor = 15.0;
    float dotWidthFactor = 10.0;
    float circleWidthFactor = self.frame.size.width / 14.2;
    
    if (!_playing)
    {
        [self addCircleSubLayerWithRadius:self.frame.size.width / dotScaleFactor width:dotWidthFactor color:[[UIColor blackColor] CGColor]];
        if (_selected)
        {
            [self addCircleSubLayerWithRadius:self.frame.size.width / 2.0 width:circleWidthFactor color:[[UIColor blackColor] CGColor]];
        }
    }
    else
    {
        if (imageTypeIndicator == 0)
        {
            if (_gameView.game.won)
            {
                if (!_selected)
                {
                    [self addCircleSubLayerWithRadius:self.frame.size.width / dotScaleFactor width:dotWidthFactor color:[[UIColor blackColor] CGColor]];
                }
                else
                {
                    self.contents = (id)[UIImage imageNamed:@"FlowerPink"].CGImage;
                }
            }
            else
            {
                if (!_selected)
                {
                    if (!_hinted)
                    {
                        [self addCircleSubLayerWithRadius:self.frame.size.width / dotScaleFactor width:dotWidthFactor color:[[UIColor blackColor] CGColor]];
                    }
                    else
                    {
                        self.contents = (id)[UIImage imageNamed:@"FlowerGray"].CGImage;
                    }
                }
                else
                {
                    self.contents = (id)[UIImage imageNamed:@"FlowerClear"].CGImage;
                }
            }
        }
        if (imageTypeIndicator == 1)
        {
            if (_gameView.game.won)
            {
                if (!_selected)
                {
                    [self addCircleSubLayerWithRadius:self.frame.size.width / dotScaleFactor width:dotWidthFactor color:[[UIColor blackColor] CGColor]];
                }
                else
                {
                    self.contents = (id)[UIImage imageNamed:@"LadybugRed"].CGImage;
                }
            }
            else
            {
                if (!_selected)
                {
                    if (!_hinted)
                    {
                        [self addCircleSubLayerWithRadius:self.frame.size.width / dotScaleFactor width:dotWidthFactor color:[[UIColor blackColor] CGColor]];
                    }
                    else
                    {
                        self.contents = (id)[UIImage imageNamed:@"LadybugGray"].CGImage;
                    }
                }
                else
                {
                    self.contents = (id)[UIImage imageNamed:@"LadybugClear"].CGImage;
                }
            }
        }
        if (imageTypeIndicator == 2)
        {
            if (_gameView.game.won)
            {
                if (!_selected)
                {
                    [self addCircleSubLayerWithRadius:self.frame.size.width / dotScaleFactor width:dotWidthFactor color:[[UIColor blackColor] CGColor]];
                }
                else
                {
                    self.contents = (id)[UIImage imageNamed:@"SkullWhite"].CGImage;
                }
            }
            else
            {
                if (!_selected)
                {
                    if (!_hinted)
                    {
                        [self addCircleSubLayerWithRadius:self.frame.size.width / dotScaleFactor width:dotWidthFactor color:[[UIColor blackColor] CGColor]];
                    }
                    else
                    {
                        self.contents = (id)[UIImage imageNamed:@"SkullGray"].CGImage;
                    }
                }
                else
                {
                    self.contents = (id)[UIImage imageNamed:@"SkullClear"].CGImage;
                }
            }
        }
        
    }
}


- (void)addCircleSubLayerWithRadius:(CGFloat)radius width:(CGFloat)width color:(CGColorRef)color
{
    CALayer* circleLayer = [CALayer layer];
    [circleLayer setMasksToBounds:YES];
    [circleLayer setCornerRadius:radius];
    [circleLayer setBorderWidth:width];
    [circleLayer setBorderColor:color];
    [circleLayer setBounds:CGRectMake(dotSpaceFactor1 * _dot.x + self.frame.size.width / 2.0 - radius, dotSpaceFactor1 * _dot.y + self.frame.size.width / 2.0 - radius, radius * 2.0, radius * 2.0)];
    [circleLayer setFrame:CGRectMake(dotSpaceFactor1 * _dot.x + self.frame.size.width / 2.0 - radius, dotSpaceFactor1 * _dot.y + self.frame.size.width / 2.0 - radius, radius * 2.0, radius * 2.0)];
    [self addSublayer:circleLayer];
}


-(BOOL)hasSameCoordsAs:(Dot*)dot
{
    return _dot.x == dot.x && _dot.y == dot.y;
}


@end
