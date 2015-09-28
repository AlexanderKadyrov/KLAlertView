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
@property (nonatomic, strong) UIView * maskView;

@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * confirmBtn;

@end

@implementation KLAlertView

#pragma mark - Private

- (CGFloat)widthForContentView {
    return 270;
}

- (void)dismissWithAnimation {
    for (UITextField * textField in self.textFieldArray) {
        [textField resignFirstResponder];
    }
    [UIView animateWithDuration:0.20f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
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
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    [self.maskView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.maskView setAlpha:0.2];
    [self.maskView setBackgroundColor:[UIColor blackColor]];
    [super addSubview:self.maskView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake((screenBounds.size.width-width)/2.0, (screenBounds.size.height-100)/2.0, width, 0)];
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
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
        CGRect frame = CGRectMake(HorizontalMargin, currentyPos, self.contentView.frame.size.width - 2*HorizontalMargin, textField.frame.size.height);
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
        [textField setLeftView:leftView];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setFont:[UIFont systemFontOfSize:16]];
        
        textField.attributedText = [self attributesForTextString:textField.text];
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = 7;
        
        UIView *viewField = [[UIView alloc] initWithFrame:frame];
        viewField.backgroundColor = textField.backgroundColor;
        viewField.layer.cornerRadius = 4;
        textField.frame = CGRectMake(8, 0, viewField.frame.size.width-16, viewField.frame.size.height);
        [viewField addSubview:textField];
        
        [self.contentView addSubview:viewField];
        currentyPos += textField.frame.size.height + 8;
    }
    [(UITextField *)[self.textFieldArray lastObject] setReturnKeyType:UIReturnKeyDone];
    currentyPos -= 3;
    
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(HorizontalMargin, currentyPos, self.contentView.frame.size.width - 2*HorizontalMargin, 16)];
    [self.hintLabel setBackgroundColor:[UIColor clearColor]];
    [self.hintLabel setFont:[UIFont systemFontOfSize:13]];
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
    self.cancelBtn = [[KLButton alloc] initWithFrame:cancelBtnFrame];
    [self.cancelBtn setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cancelBtn setTitleColor:[UIColor colorWithRed:0.525 green:0.737 blue:0.012 alpha:1] forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor colorWithRed:0.525 green:0.737 blue:0.012 alpha:1] forState:UIControlStateHighlighted];
    
    [self.contentView addSubview:self.cancelBtn];
    
    //Add vertical line
    UIView * verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width/2.0-0.5, currentyPos, 1.0, buttonHeight)];
    [verticalLineView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [verticalLineView setBackgroundColor:[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f]];
    [self.contentView addSubview:verticalLineView];
    
    //Add Confirm button
    CGRect confirmBtnFrame = CGRectMake(self.contentView.frame.size.width/2.0+0.5, currentyPos, self.contentView.frame.size.width/2.0-0.5, buttonHeight);
    self.confirmBtn = [[KLButton alloc] initWithFrame:confirmBtnFrame];
    [self.confirmBtn setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmBtn.backgroundColor = [UIColor colorWithRed:0.525 green:0.737 blue:0.012 alpha:1];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.contentView addSubview:self.confirmBtn];

    currentyPos = CGRectGetMaxY(self.confirmBtn.frame);
    
    CGRect contentFrame = self.contentView.frame;
    contentFrame.size.height = currentyPos;
    contentFrame.origin.y = 100;
    [self.contentView setFrame:contentFrame];

    [super addSubview:self.contentView];
}

- (NSMutableAttributedString *)attributesForTextString:(NSString *)string {
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
    
    
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                 
                                 NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:14],
                                 
                                 NSParagraphStyleAttributeName:paragrahStyle};
    
    
    
    return [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
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

- (void)layoutSubviews {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect frame = self.contentView.frame;
    frame.origin.x = (screenBounds.size.width-frame.size.width)/2.0;
    if (screenBounds.size.width > screenBounds.size.height) {
        frame.origin.y = 5;
    }else {
        frame.origin.y = 100;
    }
    [self.contentView setFrame:frame];
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
                         [self.contentView.layer setTransform:CATransform3DIdentity];
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


@interface KLButton()

@end

@implementation KLButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setShowsTouchWhenHighlighted:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        return self;
    }
    return nil;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    [super setBackgroundColor:bgColor];
}

@end