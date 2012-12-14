//
//  AMLoadingViewController.m
//  appic
//
//  Created by Michael Kamphausen on 24.10.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "AMLoadingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CustomColors.h"

@interface AMLoadingViewController ()

@end

@implementation AMLoadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_eyecatcher.layer.cornerRadius = 10.0f;
    _eyecatcher.layer.masksToBounds = YES;
    _eyecatcher.layer.borderColor = [UIColor lightBorderColor].CGColor;
    _eyecatcher.layer.borderWidth = 2.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    UIView* thisView = self.view;
    thisView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.view.superview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:thisView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.view.superview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:thisView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [thisView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[thisView(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(thisView)]];
    [thisView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[thisView(300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(thisView)]];
    [thisView updateConstraints];
    [self.view.superview updateConstraints];
}

@end
