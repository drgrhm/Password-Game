//
//  Dot.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-10.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "Dot.h"

@implementation Dot

#pragma mark NSCoding

-(id)initWithCoords:(int)x and:(int)y
{
    self = [super init];
    if (self)
    {
        _x = x;
        _y = y;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        _x = [coder decodeIntForKey:@"x"];
        _y = [coder decodeIntForKey:@"y"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:_x forKey:@"x"];
    [coder encodeInt:_y forKey:@"y"];
}


-(BOOL)isEqual:(Dot*)otherDot
{
    if (_x == otherDot.x && _y == otherDot.y)
    {
        return true;
    }
    return false;
}



@end
