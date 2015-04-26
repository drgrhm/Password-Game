//
//  Dot.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-10.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dot : NSObject <NSCoding>

@property int x;
@property int y;

-(id)initWithCoords:(int)x and:(int)y;
-(BOOL)isEqual:(Dot*)otherDot;

@end
