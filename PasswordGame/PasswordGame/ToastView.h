//
//  ToastView.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-02-14.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property (strong, nonatomic) NSString *text;

+ (ToastView*)showToastInParentView:(UIView*)parentView
                           withText:(NSString*)text
                      withDuaration:(float)duration;


@end
