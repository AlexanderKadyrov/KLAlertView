//
//  KLAlertView.h
//  KLAlertViewDemo
//
//  Created by kinglong huang on 5/8/15.
//  Copyright (c) 2015 KLStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLAlertView : UIView

@property (copy) void (^cancelBlock)(KLAlertView *alertView);
@property (copy) void (^confirmBlock)(KLAlertView *alertView);

- (instancetype)initWithTitle:(NSString *)title textFields:(NSArray *)textFieldArray cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle;

- (void)show;

- (UITextField *)textFieldAtIndex:(NSInteger)index;

@end
