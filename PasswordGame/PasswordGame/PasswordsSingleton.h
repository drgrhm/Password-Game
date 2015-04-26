//
//  PasswordsSingleton.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-27.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordsSingleton : NSObject <NSCoding>
{
    NSMutableArray* saved3DPasswords;
    NSMutableArray* saved4DPasswords;
    NSMutableArray* saved5DPasswords;
}

@property (nonatomic, retain) NSMutableArray* saved3DPasswords;
@property (nonatomic, retain) NSMutableArray* saved4DPasswords;
@property (nonatomic, retain) NSMutableArray* saved5DPasswords;

+ (id)sharedPasswordsSingleton;

@end
