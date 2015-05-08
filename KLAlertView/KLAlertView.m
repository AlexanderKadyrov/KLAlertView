//
//  KLAlertView.m
//  KLAlertViewDemo
//
//  Created by kinglong huang on 5/8/15.
//  Copyright (c) 2015 KLStudio. All rights reserved.
//

#import "KLAlertView.h"

#define HorizontalMargin        20
#define VerticalMargin          15

@interface KLAlertView()

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * cancelButtonTitle;
@property (nonatomic, strong) NSString * confirmButtonTitle;
@property (nonatomic, strong) NSArray * textFieldArray;
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * confirmBtn;

@end

@implementation KLAlertView

#pragma mark - Private

- (CGFloat)widthForContentView {
    CGFloat maxWidthOfTextField = 0.0;
    for (UITextField * textField in self.textFieldArray) {
        if ([textField isKindOfClass:[UITextField class]]) {
            if (maxWidthOfTextField < textField.frame.size.width) {
                maxWidthOfTextField = textField.frame.size.width;
            }
        }
    }
    CGFloat result = MAX((maxWidthOfTextField + 2*HorizontalMargin), 280);
    return result;
}

- (void)layout {
    CGFloat width = [self widthForContentView];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [self setFrame:screenBounds];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIView * maskView = [[UIView alloc] initWithFrame:self.bounds];
    [maskView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [maskView setAlpha:0.4];
    [maskView setBackgroundColor:[UIColor blackColor]];
    [super addSubview:maskView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake((screenBounds.size.width-width)/2.0, (screenBounds.size.height-100)/2.0, width, 0)];
    [self.contentView.layer setCornerRadius:6.0];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    UIFont * titleFont = [UIFont boldSystemFontOfSize:17];
    CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName : titleFont}];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width- titleSize.width)/2.0, 10, titleSize.width, titleSize.height)];
    [titleLabel setFont:titleFont];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:self.title];
    [self.contentView addSubview:titleLabel];

    CGFloat currentyPos = CGRectGetMaxY(titleLabel.frame) + VerticalMargin;
    for (UITextField * textField in self.textFieldArray) {
        CGRect frame = CGRectMake(HorizontalMargin, currentyPos, self.contentView.frame.size.width - 2*HorizontalMargin, textField.frame.size.height);
        [textField setFrame:frame];
        [textField setBorderStyle:UITextBorderStyleBezel];
        [textField.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [textField.layer setBorderWidth:1.0];
        [self.contentView addSubview:textField];
        currentyPos += textField.frame.size.height + 3;
    }
    
    currentyPos += VerticalMargin - 3;
    
    //Add horizontal line
    UIView * horizontalLineView = [[UIView alloc] initWithFrame:CGRectMake(0, currentyPos, self.contentView.frame.size.width, 1.0)];
    [horizontalLineView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [horizontalLineView setBackgroundColor:[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f]];
    [self.contentView addSubview:horizontalLineView];
    
    currentyPos = CGRectGetMaxY(horizontalLineView.frame);
    
    CGFloat buttonHeight = 40;
    //Add cancel button
    CGRect cancelBtnFrame = CGRectMake(0, currentyPos, self.contentView.frame.size.width/2.0-0.5, buttonHeight);
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
    if (btn ==  self.cancelBtn) {
        self.cancelBlock(self);
    }else if (btn ==  self.confirmBtn) {
        self.confirmBlock(self);
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        self.contentView.layer.transform = CATransform3DConcat(self.contentView.layer.transform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
        self.contentView.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
    self.contentView.layer.transform = CATransform3DMakeScale(1.1f, 1.1f, 1.0);
    
    [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.contentView.layer.opacity = 1.0f;
                         self.contentView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.06 animations:^{
                             self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                             self.contentView.layer.opacity = 1.0f;
                             self.contentView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                         }];
                     }
     ];
    
    [[self textFieldAtIndex:0] becomeFirstResponder];
}

- (UITextField *)textFieldAtIndex:(NSInteger)index {
    if (index >=0 && index < self.textFieldArray.count) {
        return [self.textFieldArray objectAtIndex:index];
    }
    return nil;
}

@end
