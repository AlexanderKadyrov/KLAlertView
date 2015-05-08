//
//  ViewController.m
//  KLAlertViewDemo
//
//  Created by kinglong huang on 5/8/15.
//  Copyright (c) 2015 KLStudio. All rights reserved.
//

#import "ViewController.h"
#import "KLAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setTitle:@"Show" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(20, 100, 100, 30)];
    [btn addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)showAlertView {
    UITextField * textfiled1 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [textfiled1 setBackgroundColor:[UIColor clearColor]];
    [textfiled1 setBorderStyle:UITextBorderStyleLine];
    UITextField * textfiled2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    [textfiled2 setBackgroundColor:[UIColor clearColor]];
    [textfiled2 setBorderStyle:UITextBorderStyleLine];
    KLAlertView * alertView = [[KLAlertView alloc] initWithTitle:@"Hello, world" textFields:@[textfiled1, textfiled2] cancelButtonTitle:@"Cancel" confirmButtonTitle:@"OK"];
    [alertView setCancelBlock:^(KLAlertView * alertView) {
        NSLog(@"%@",[[alertView textFieldAtIndex:0] text]);
    }];
    [alertView setConfirmBlock:^(KLAlertView * alertView) {
        NSLog(@"%@",[[alertView textFieldAtIndex:1] text]);
    }];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
