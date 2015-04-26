//
//  SavedPasswords.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-02-14.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "SavedPasswords.h"

@implementation SavedPasswords


#pragma mark NSCoding

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (self)
    {
        _saved3DPasswords = [coder decodeObjectForKey:@"saved3DPasswords"];
        if (_saved3DPasswords == nil)
        {
            _saved3DPasswords = [[NSMutableArray alloc] init];
        }
        _saved4DPasswords = [coder decodeObjectForKey:@"saved4DPasswords"];
        if (_saved4DPasswords == nil)
        {
            _saved4DPasswords = [[NSMutableArray alloc] init];
        }
        _saved5DPasswords = [coder decodeObjectForKey:@"saved5DPasswords"];
        if (_saved5DPasswords == nil)
        {
            _saved5DPasswords = [[NSMutableArray alloc] init];
        }
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_saved3DPasswords forKey:@"saved3DPasswords"];
    [coder encodeObject:_saved4DPasswords forKey:@"saved4DPasswords"];
    [coder encodeObject:_saved5DPasswords forKey:@"saved5DPasswords"];
}


@end
