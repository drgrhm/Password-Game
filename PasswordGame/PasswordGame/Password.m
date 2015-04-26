//
//  Password.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-10.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "Password.h"

@implementation Password

#pragma mark NSCoding

-(id)init
{
    self = [super init];
    if (self)
    {
        _dots = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return self;
}


-(id)initWithCopyingDots:(NSMutableArray*)dots
{
    self = [super init];
    if (self)
    {
        _dots = [[NSMutableArray alloc] initWithCapacity:30];
        [_dots addObjectsFromArray:dots];
    }
    return self;
}


- (id)initWithString:(NSString*) passwordString
{
    self = [super init];
    if (self)
    {
        _dots = [[NSMutableArray alloc] initWithCapacity:30];
        NSString* remainderString = passwordString;
        @try
        {
            Dot* sendingDot = [[Dot alloc] initWithCoords:[remainderString substringWithRange:(NSMakeRange(1, 1))].intValue
                                                      and:[remainderString substringWithRange:(NSMakeRange(3, 3))].intValue];
            [_dots addObject:sendingDot];
            remainderString = [remainderString substringFromIndex:(5)];
            Dot* receivingDot;
            while (remainderString.length >= 5)
            {
                receivingDot = [[Dot alloc] initWithCoords:[remainderString substringWithRange:(NSMakeRange(1, 1))].intValue
                                                       and:[remainderString substringWithRange:(NSMakeRange(3, 1))].intValue];
                [_dots addObject:receivingDot];
                sendingDot = receivingDot;
                remainderString = [remainderString substringFromIndex:(5)];
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"exception.name: %@ . exception.reason: %@ .", exception.name, exception.reason);
        }
        @finally
        {
            //....
        }
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        _dots = [coder decodeObjectForKey:@"dots"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_dots forKey:@"dots"];
}


- (void)addDot:(Dot*) dot
{
    [_dots addObject:dot];
}


- (void)clear
{
    [_dots removeAllObjects];
}


- (void)setTo:(Password*)other
{
    [_dots removeAllObjects];
    [_dots addObjectsFromArray:other.dots];
}


- (BOOL)containsPoint:(int)x :(int)y
{
    if (_dots.count > 0)
    {
        for (Dot* dot in _dots)
        {
            if (dot.x == x && dot.y == y)
            {
                return true;
            }
        }
    }
    return false;
}


- (BOOL)isEqual:(Password*)otherPassword
{
    if ( _dots.count != otherPassword.dots.count)
    {
        return false;
    }
    else
    {
        for (int i = 0; i < _dots.count; i++)
        {
            if (![[_dots objectAtIndex:i] isEqual:[otherPassword.dots objectAtIndex:i]])
            {
                return false;
            }
        }
        return true;
    }
}


- (void)copyPassword:(Password*)otherPassword
{
    [_dots removeAllObjects];
    for (Dot* dot in otherPassword.dots)
    {
        Dot* newDot = [[Dot alloc] initWithCoords:dot.x and:dot.y];
        [_dots addObject:newDot];
    }
}


- (NSMutableArray*)getLines
{
    NSMutableArray* lines = [[NSMutableArray alloc] initWithCapacity:26];
    Line* line;
    for (int i = 0; i < _dots.count - 1; i++)
    {
        line = [[Line alloc] initWithFromDot:[_dots objectAtIndex:i] toDot:[_dots objectAtIndex:i + 1]];
        [lines addObject:line];
    }
    return lines;
}


@end













