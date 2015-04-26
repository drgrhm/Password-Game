//
//  ToastView.m
//  PasswordGame
//
//  Created by Devon R Graham on 2015-02-14.
//  Copyright (c) 2015 Devon R Graham. All rights reserved.
//

#import "ToastView.h"

@interface ToastView ()
@property (strong, nonatomic, readonly) UILabel *textLabel;
@end
@implementation ToastView
@synthesize textLabel = _textLabel;

float const ToastHeight = 70.0f;

-(UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
        _textLabel.numberOfLines = 3;
        _textLabel.font = [UIFont systemFontOfSize:17.0];
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_textLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:0.9
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.9
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
        
    }
    return _textLabel;
}


- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
}


+ (ToastView*)showToastInParentView:(UIView*)parentView
                           withText:(NSString*)text
                      withDuaration:(float)duration;
{
    ToastView *toast = [[ToastView alloc] init];
    
    toast.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
    toast.alpha = 0.0f;
    toast.layer.cornerRadius = 30.0;
    toast.text = text;
    
    [toast setTranslatesAutoresizingMaskIntoConstraints:NO];
    [parentView addSubview:toast];
    
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:toast
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parentView
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:0.75
                                                            constant:0]];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:toast
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:1.0
                                                            constant:ToastHeight]];
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:toast
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parentView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0.0]];
    
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:toast
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:parentView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.8
                                                            constant:0.0]];
    [UIView animateWithDuration:0.4 animations:^{
        toast.alpha = 0.5f;
        toast.textLabel.alpha = 1.0f;
    }completion:^(BOOL finished) {
        if(finished){
            
        }
    }];
    [toast performSelector:@selector(hideSelf) withObject:nil afterDelay:duration];
    
    return toast;
    
}


- (void)hideSelf
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
        self.textLabel.alpha = 0.0;
    }completion:^(BOOL finished) {
        if(finished){
            [self removeFromSuperview];
        }
    }];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end





