//
//  Line.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-02-06.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dot.h"

@interface Line : NSObject

@property Dot* fromDot;
@property Dot* toDot;

-(id)initWithFromDot:(Dot*)fromDot toDot:(Dot*)toDot;
- (BOOL)isEqual:(Line*)otherLine;
@end
