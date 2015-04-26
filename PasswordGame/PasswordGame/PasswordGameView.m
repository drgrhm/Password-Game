//
//  PasswordGameView.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-10.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "PasswordGameView.h"
#import "PasswordGameDotLayer.h"
#import "PasswordGameLineLayer.h"

@implementation PasswordGameView
{
    PasswordGameDotLayer* currentDotLayer;
    PasswordGameDotLayer* previousDotLayer;
    PasswordGameLineLayer* currentLineLayer;
    PasswordGameLineLayer* previousLineLayer;
    UIBezierPath *currentPath;
    UIBezierPath *previousPath;
    float gameSize;
    float dotSize;
    float dotSizeScaleFactor;
    float dotSpacingFactor0;
    float dotSpacingFactor1;
    float lineWidth;
}


- (id)initWithFrame:(CGRect)frame
               game:(Game*)game
 imageTypeIndicator:(int)imageTypeIndicator
 dotSizeScaleFactor:(float)d
gameViewScaleFactor:(float)gameViewScaleFactor
  dotSpacingFactor0:(float)d0
  dotSpacingFactor1:(float)d1
           lineSize:(float)lineSize
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _game = game;
        _imageTypeIndicator = imageTypeIndicator;
        _dotLayers = [[NSMutableArray alloc] initWithCapacity:26];
        _lineLayers = [[NSMutableArray alloc] initWithCapacity:26];
        _hintedDotLayers = [[NSMutableArray alloc] initWithCapacity:26];
        _hintedLineLayers = [[NSMutableArray alloc] initWithCapacity:26];
        _correctPasswordLineLayers = [[NSMutableArray alloc] initWithCapacity:26];
        gameSize = MIN(self.bounds.size.height, self.bounds.size.width);
        dotSizeScaleFactor = d;
        dotSpacingFactor0 = d0;
        dotSpacingFactor1 = d1;
        lineWidth = lineSize;
        
        int x = 0;
        int y = 0;
        float xPos = dotSpacingFactor1 / 2 - dotSpacingFactor0;
        float yPos = dotSpacingFactor1 / 2 - dotSpacingFactor0;
        Dot* dot;
        PasswordGameDotLayer* dotLayer;
        while (x < _game.dimension)
        {
            while (true)
            {
                dot = [[Dot alloc] initWithCoords:x and:y];
                dotLayer = [[PasswordGameDotLayer alloc] initWithDot:dot
                                                  dotSizeScaleFactor:dotSizeScaleFactor
                                                     dotSpaceFactor0:dotSpacingFactor0
                                                     dotSpaceFactor1:dotSpacingFactor1
                                                  imageTypeIndicator:imageTypeIndicator];
                dotLayer.gameView = self;
                dotLayer.frame = CGRectMake(xPos, yPos, 2 * dotSpacingFactor0, 2 * dotSpacingFactor0);
                [_dotLayers addObject:dotLayer];
                [self.layer insertSublayer:dotLayer atIndex:0];
                [dotLayer setNeedsDisplay];
                y++;
                yPos += dotSpacingFactor1;
                if (y >= game.dimension)
                {
                    y = 0;
                    yPos = dotSpacingFactor1 / 2 - dotSpacingFactor0;
                    x ++;
                    xPos += dotSpacingFactor1;
                    break;
                }
            }
        }
    }
    return self;
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch
                     withEvent:(UIEvent *)event
{
    [_lineLayers removeAllObjects];
    BOOL tracking = false;
    for (PasswordGameDotLayer* dotLayer in _dotLayers)
    {
        if (self.enabled)
        {
            dotLayer.enabled = true;
        }
        if(CGRectContainsPoint(dotLayer.frame, [touch locationInView:self]))
        {
            currentDotLayer = dotLayer;
            dotLayer.selected = YES;
            [dotLayer setNeedsDisplay];
            Dot* dot = [[Dot alloc] initWithCoords:dotLayer.dot.x and:dotLayer.dot.y];
            [_game.selectedPassword addDot:dot];
            currentLineLayer = [[PasswordGameLineLayer alloc] initWithFromDot:dot
                                                                        toDot:nil
                                                            dotSpacingFactor0:dotSpacingFactor0
                                                            dotSpacingFactor1:dotSpacingFactor1];
            currentLineLayer.lineWidth = lineWidth;
            currentLineLayer.gameView = self;
            [self.layer insertSublayer:currentLineLayer atIndex:50];
            tracking = true;
        }
    }
    return tracking;
}


- (BOOL)continueTrackingWithTouch:(UITouch *)touch
                        withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    for (PasswordGameDotLayer* dotLayer in _dotLayers)
    {
        if([self rectIntersects:dotLayer.frame
                   withLineFrom:CGPointMake(currentDotLayer.centerX, currentDotLayer.centerY)
                             to:touchPoint])
        {
            if (!dotLayer.selected)
            {
                previousDotLayer = currentDotLayer;
                currentDotLayer = dotLayer;
                currentDotLayer.selected = YES;
                [_game.selectedPassword addDot:dotLayer.dot];
                previousPath = [UIBezierPath bezierPath];
                CGPoint fromPoint = CGPointMake(previousDotLayer.centerX, previousDotLayer.centerY);
                CGPoint toPoint = CGPointMake(currentDotLayer.centerX, currentDotLayer.centerY);
                [previousPath moveToPoint:fromPoint];
                [previousPath addLineToPoint:toPoint];
                previousLineLayer = [[PasswordGameLineLayer alloc] initWithFromDot:previousDotLayer.dot
                                                                             toDot:currentDotLayer.dot
                                                                 dotSpacingFactor0:dotSpacingFactor0
                                                                 dotSpacingFactor1:dotSpacingFactor1];
                previousLineLayer.lineWidth = lineWidth;
                previousLineLayer.gameView = self;
                previousLineLayer.path = [previousPath CGPath];
                [_lineLayers addObject:previousLineLayer];
                [self.layer insertSublayer:previousLineLayer atIndex:50];
                [previousLineLayer setNeedsDisplay];
                [currentDotLayer setNeedsDisplay];
                break;
            }
        }
    }
    currentPath = [UIBezierPath bezierPath];
    [currentPath moveToPoint:CGPointMake(currentDotLayer.centerX, currentDotLayer.centerY)];
    [currentPath addLineToPoint:CGPointMake(touchPoint.x, touchPoint.y)];
    currentLineLayer.path = [currentPath CGPath];
    [currentLineLayer setNeedsDisplay];
    // 3. Update the UI state
    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;
    [CATransaction commit];
    return YES;
}


- (BOOL)rectIntersects:(CGRect)rect
          withLineFrom:(CGPoint)from
                    to:(CGPoint)to
{
    CGPoint point0 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint point1 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    if ([self checkLineIntersection:from :to :point0 :point1])
    {
        return true;
    }
    if ([self checkLineIntersection:from :to :point1 :point2])
    {
        return true;
    }
    if ([self checkLineIntersection:from :to :point2 :point3])
    {
        return true;
    }
    if ([self checkLineIntersection:from :to :point3 :point0])
    {
        return true;
    }
    return false;
}


- (BOOL)checkLineIntersection:(CGPoint)p1 :(CGPoint)p2 :(CGPoint)p3 :(CGPoint)p4
{
    CGFloat denominator = (p4.y - p3.y) * (p2.x - p1.x) - (p4.x - p3.x) * (p2.y - p1.y);
    CGFloat ua = (p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x);
    CGFloat ub = (p2.x - p1.x) * (p1.y - p3.y) - (p2.y - p1.y) * (p1.x - p3.x);
    if (denominator < 0)
    {
        ua = -ua;
        ub = -ub;
        denominator = -denominator;
    }
    return (ua > 0.0 && ua <= denominator && ub > 0.0 && ub <= denominator);
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.enabled = false;
    [currentLineLayer removeFromSuperlayer];
    [NSThread sleepForTimeInterval:0.3f];
    if (_playing)
    {
        [NSThread sleepForTimeInterval:0.3f];
        if ([_game.selectedPassword isEqual:_game.correctPassword])
        {
            _game.won = true;
        }
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (void)setUpCorrectPasswordLineLayers
{
    PasswordGameLineLayer* lineLayer;
    UIBezierPath* path;
    CGPoint fromPoint;
    CGPoint toPoint;
    for (int i = 0; i < _game.correctPassword.dots.count - 1; i++)
    {
        path = [UIBezierPath bezierPath];
        fromPoint = CGPointMake((((Dot*)[_game.correctPassword.dots objectAtIndex:i]).x * dotSpacingFactor1 + dotSpacingFactor0 / dotSizeScaleFactor), (((Dot*)[_game.correctPassword.dots objectAtIndex:i]).y * dotSpacingFactor1 + dotSpacingFactor0 / dotSizeScaleFactor));
        toPoint = CGPointMake((((Dot*)[_game.correctPassword.dots objectAtIndex:i + 1]).x * dotSpacingFactor1 + dotSpacingFactor0 / dotSizeScaleFactor), (((Dot*)[_game.correctPassword.dots objectAtIndex:i + 1]).y * dotSpacingFactor1 + dotSpacingFactor0 / dotSizeScaleFactor));
        [path moveToPoint:fromPoint];
        [path addLineToPoint:toPoint];
        lineLayer = [[PasswordGameLineLayer alloc] initWithFromDot:[_game.correctPassword.dots objectAtIndex:i]
                                                             toDot:[_game.correctPassword.dots objectAtIndex:i + 1]
                                                 dotSpacingFactor0:dotSpacingFactor0
                                                 dotSpacingFactor1:dotSpacingFactor1];
        lineLayer.lineWidth = lineWidth;
        lineLayer.gameView = self;
        [self.correctPasswordLineLayers addObject:lineLayer];
        [self.layer insertSublayer:lineLayer atIndex:0];
        lineLayer.path = [path CGPath];
    }
}


@end












