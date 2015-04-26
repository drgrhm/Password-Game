//
//  Password.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-10.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dot.h"
#import "Line.h"

@interface Password : NSObject <NSCoding>

@property NSMutableArray* dots;

- (id)initWithCopyingDots:(NSMutableArray*)dots;
- (id)initWithString:(NSString*) passwordString;
- (void)addDot:(Dot*) dot;
- (void)clear;
- (void)setTo:(Password*)other;
- (BOOL)containsPoint:(int)x :(int)y;
- (void)copyPassword:(Password*)otherPassword;
- (NSMutableArray*)getLines;

@end
