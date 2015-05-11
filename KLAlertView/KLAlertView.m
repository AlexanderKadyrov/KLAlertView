//
//  KLAlertView.m
//  KLAlertViewDemo
//
//  Created by kinglong huang on 5/8/15.
//  Copyright (c) 2015 KLStudio. All rights reserved.
//

#import "KLAlertView.h"

#define HorizontalMargin        15
#define VerticalMargin          15

@interface KLAlertView()

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * cancelButtonTitle;
@property (nonatomic, strong) NSString * confirmButtonTitle;
@property (nonatomic, strong) NSArray * textFieldArray;
@property (nonatomic, strong) UILabel * hintLabel;
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * confirmBtn;

@end

@implementation KLAlertView

#pragma mark - Private

- (CGFloat)widthForContentView {
    return 270;
}

- (void)dismissWithAnimation {
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        self.contentView.layer.transform = CATransform3DConcat(self.contentView.layer.transform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
        self.contentView.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layout {
    CGFloat width = [self widthForContentView];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [self setFrame:screenBounds];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIView * maskView = [[UIView alloc] initWithFrame:self.bounds];
    [maskView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [maskView setAlpha:0.2];
    [maskView setBackgroundColor:[UIColor blackColor]];
    [super addSubview:maskView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake((screenBounds.size.width-width)/2.0, (screenBounds.size.height-100)/2.0, width, 0)];
    [self.contentView.layer setCornerRadius:6.0];
    [self.contentView.layer setMasksToBounds:YES];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    UIFont * titleFont = [UIFont boldSystemFontOfSize:17];
    CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName : titleFont}];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width- titleSize.width)/2.0, 20, titleSize.width, titleSize.height)];
    [titleLabel setFont:titleFont];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:self.title];
    [self.contentView addSubview:titleLabel];

    CGFloat currentyPos = CGRectGetMaxY(titleLabel.frame) + VerticalMargin;
    for (UITextField * textField in self.textFieldArray) {
        CGRect frame = CGRectMake(HorizontalMargin, currentyPos, self.contentView.frame.size.width - 2*HorizontalMargin, 25);
        [textField setFrame:frame];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setFont:[UIFont systemFontOfSize:14]];
        [textField.layer setBorderColor:[UIColor blackColor].CGColor];
        [textField.layer setBorderWidth:0.5];
        [self.contentView addSubview:textField];
        currentyPos += textField.frame.size.height + 8;
    }
    [(UITextField *)[self.textFieldArray lastObject] setReturnKeyType:UIReturnKeyDone];
    currentyPos -= 4;
    
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(HorizontalMargin, currentyPos, self.contentView.frame.size.width - 2*HorizontalMargin, 14)];
    [self.hintLabel setBackgroundColor:[UIColor clearColor]];
    [self.hintLabel setFont:[UIFont systemFontOfSize:11]];
    [self.hintLabel setTextColor:[UIColor redColor]];
    [self.contentView addSubview:self.hintLabel];
    
    currentyPos = CGRectGetMaxY(self.hintLabel.frame) + 3;
    
    //Add horizontal line
    UIView * horizontalLineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentyPos, self.contentView.frame.size.width, 1.0)];
    [horizontalLineView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [horizontalLineView setBackgroundColor:[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f]];
    [self.contentView addSubview:horizontalLineView];
    
    currentyPos = CGRectGetMaxY(horizontalLineView.frame);
    
    CGFloat buttonHeight = 40;
    //Add cancel button
    CGRect cancelBtnFrame = CGRectMake(0, currentyPos, self.contentView.frame.size.width/2.0-0.5, buttonHeight);
    self.cancelBtn = [[KLButton alloc] init];
    [self.cancelBtn setShowsTouchWhenHighlighted:YES];
    [self.cancelBtn setFrame:cancelBtnFrame];
    [self.cancelBtn setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.cancelBtn setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor clearColor]];
    [self.cancelBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelBtn];
    
    //Add vertical line
    UIView * verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width/2.0-0.5, currentyPos, 1.0, buttonHeight)];
    [verticalLineView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [verticalLineView setBackgroundColor:[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f]];
    [self.contentView addSubview:verticalLineView];
    
    //Add Confirm button
    CGRect confirmBtnFrame = CGRectMake(self.contentView.frame.size.width/2.0+0.5, currentyPos, self.contentView.frame.size.width/2.0-0.5, buttonHeight);
    self.confirmBtn = [[KLButton alloc] init];
    [self.confirmBtn setShowsTouchWhenHighlighted:YES];
    [self.confirmBtn setFrame:confirmBtnFrame];
    [self.confirmBtn setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.confirmBtn setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundColor:[UIColor clearColor]];
    [self.confirmBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.confirmBtn];

    currentyPos = CGRectGetMaxY(self.confirmBtn.frame);
    
    CGRect contentFrame = self.contentView.frame;
    contentFrame.size.height = currentyPos;
    contentFrame.origin.y = 100;
    [self.contentView setFrame:contentFrame];

    [super addSubview:self.contentView];
}

#pragma mark - Action

- (void)dismiss:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (btn == self.cancelBtn && self.cancelBlock) {
        self.cancelBlock(self);
    }else if (btn ==  self.confirmBtn && self.confirmBlock) {
        self.confirmBlock(self);
    }else {
        [self dismissWithAnimation];
    }
}

#pragma mark - Override

- (void)addSubview:(UIView *)view {
    ;
}

#pragma mark - Public

- (instancetype)initWithTitle:(NSString *)title textFields:(NSArray *)textFieldArray cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle {
    self = [super init];
    if (self) {
        self.textFieldArray = textFieldArray;
        self.title = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.confirmButtonTitle = confirmButtonTitle;
        [self layout];
        return self;
    }
    return nil;
}

- (void)show {
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    self.contentView.layer.opacity = 0.5f;
    self.contentView.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.contentView.layer.opacity = 1.0f;
                         self.contentView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:^(BOOL finished) {
                     }
     ];
    
    [[self textFieldAtIndex:0] becomeFirstResponder];
}

- (void)dismiss {
    [self dismissWithAnimation];
}

- (void)setHint:(NSString *)hint {
    [self.hintLabel setText:hint];
}

- (UITextField *)textFieldAtIndex:(NSInteger)index {
    if (index >=0 && index < self.textFieldArray.count) {
        return [self.textFieldArray objectAtIndex:index];
    }
    return nil;
}

@end


@implementation KLButton

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.8]];
    }else {
        [self setBackgroundColor:[UIColor clearColor]];
    }
}

@end