//
//  PasswordsSingleton.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-27.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "PasswordsSingleton.h"

@implementation PasswordsSingleton

#pragma mark NSCoding

@synthesize saved3DPasswords;
@synthesize saved4DPasswords;
@synthesize saved5DPasswords;


+ (id)sharedPasswordsSingleton {
    static PasswordsSingleton *savedPasswordsSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        savedPasswordsSingleton = [[self alloc] init];
    });
    return savedPasswordsSingleton;
}

- (id)initWithCoder:(NSCoder*)coder {
    if (self = [super init])
    {
        saved3DPasswords = [coder decodeObjectForKey:@"saved3DPasswords"];
        if (saved3DPasswords == nil)
        {
            saved3DPasswords = [[NSMutableArray alloc] init];
        }
        saved4DPasswords = [coder decodeObjectForKey:@"saved4DPasswords"];
        if (saved4DPasswords == nil)
        {
            saved4DPasswords = [[NSMutableArray alloc] init];
        }
        saved5DPasswords = [coder decodeObjectForKey:@"saved5DPasswords"];
        if (saved5DPasswords == nil)
        {
            saved5DPasswords = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:saved3DPasswords forKey:@"saved3DPasswords"];
    [coder encodeObject:saved4DPasswords forKey:@"saved4DPasswords"];
    [coder encodeObject:saved5DPasswords forKey:@"saved5DPasswords"];
}

@end
