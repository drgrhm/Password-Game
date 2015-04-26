//
//  Game.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-11.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Password.h"

@interface Game : NSObject

@property int dimension;
@property Password* correctPassword;
@property Password* selectedPassword;
@property NSMutableArray* hintedDots;
@property NSMutableArray* hintedLines;
@property BOOL won;


-(id)initWithDimension:(int)dimension
       correctPassword:(Password *)correctPassword
      selectedPassword:(Password *)selectedPassword
            hintedDots:(NSMutableArray*)hintedDots
           hintedLines:(NSMutableArray*)hintedLines;

@end
