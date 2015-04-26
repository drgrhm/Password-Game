//
//  BackgroundView.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-31.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "BackgroundView.h"

@implementation BackgroundView


+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.layer.colors = [NSArray arrayWithObjects:(id)[[[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.2 alpha:1.0] CGColor], (id)[[UIColor clearColor] CGColor], nil];
        self.layer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.5], nil];
        self.layer.startPoint = CGPointMake(0.0, 0.0);
        self.layer.endPoint = CGPointMake(2.0, 2.0);
        self.layer.opacity = 0.1;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
