//
//  Line.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-02-06.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "Line.h"

@implementation Line


-(id)initWithFromDot:(Dot*)fromDot toDot:(Dot*)toDot
{
    self = [super init];
    if (self)
    {
        _fromDot = fromDot;
        _toDot = toDot;
    }
    return self;
}


- (BOOL)isEqual:(Line*)otherLine
{
    return [_fromDot isEqual:otherLine.fromDot] && [_toDot isEqual:otherLine.toDot];
}


@end
