//
//  Game.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-11.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "Game.h"

@implementation Game


-(id)initWithDimension:(int)dimension
       correctPassword:(Password *)correctPassword
      selectedPassword:(Password *)selectedPassword
            hintedDots:(NSMutableArray*)hintedDots
           hintedLines:(NSMutableArray*)hintedLines
{
    self = [super init];
    if (self)
    {
        _dimension = dimension;
        _correctPassword = correctPassword;
        _selectedPassword = selectedPassword;
        _hintedDots = hintedDots;
        _hintedLines = hintedLines;
        _won = _correctPassword != nil && _selectedPassword == _correctPassword;
    }
    return self;
}


@end
