//
//  SavedPasswords.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-02-14.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedPasswords : NSObject <NSCoding>

@property NSMutableArray* saved3DPasswords;
@property NSMutableArray* saved4DPasswords;
@property NSMutableArray* saved5DPasswords;

@end
