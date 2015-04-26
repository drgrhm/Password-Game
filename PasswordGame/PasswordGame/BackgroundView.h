//
//  BackgroundView.h
//  PasswordGame
//
//  Created by Devon R Graham on 2015-01-31.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundView : UIView

@property (nonatomic, strong, readonly) CAGradientLayer *layer;

- (id)initWithFrame:(CGRect)frame;

@end
