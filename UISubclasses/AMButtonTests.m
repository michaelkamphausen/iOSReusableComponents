//
//  AMButtonTests.m
//  appic
//
//  Created by Caro N on 10/17/2012.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "AMButtonTests.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CustomColors.h"

@implementation AMButtonTests

- (void)setUp
{
    [super setUp];
    button = [[AMButton alloc] init];
    assertThat(button, notNilValue());
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testSetupDefault
{
    NSString* title = @"epic!";
    [button setTitle:title forState:UIControlStateNormal];
    [button setupDefault];
    assertThat([button currentBackgroundImage], notNilValue());
    assertThat(button.subviews, hasCountOf(1));
    assertThat([button.subviews.lastObject class], equalTo([AMLabel class]));
    assertThat(((AMLabel*)(button.subviews.lastObject)).text, equalTo(title));
    assertThat([button titleForState:UIControlStateNormal], equalTo(@""));
}

- (void) testSetText
{
    [button setText: @"next" withMargin:20 constantSize:NO];
    assertThat(button.subviews, hasCountOf(1));
    assertThat([[button.subviews lastObject] class], equalTo([AMLabel class]));
    assertThatInteger([[button constraints] count], greaterThan([NSNumber numberWithInt:0]));
    assertThat([[button.subviews lastObject] backgroundColor], equalTo([UIColor clearColor]));
    assertThat([[button.subviews lastObject] text], notNilValue());
    [button setText: @"next" withMargin:20 constantSize:YES];
    assertThat(button.subviews, hasCountOf(1));
    assertThatBool(((AMLabel*)[button.subviews lastObject]).translatesAutoresizingMaskIntoConstraints, equalToBool(NO));
    assertThatInteger([[button constraints]count], greaterThan([NSNumber numberWithInt:0]));
}

- (void) testSetImage
{
    [button setImage:[UIImage imageNamed:@"button_bg_rot.png"]];
    assertThat(button.subviews, hasCountOf(0));
    assertThat([button currentBackgroundImage], notNilValue());
}

- (void) testSetEnabled
{
    [button setText:@"disabled" withMargin:20 constantSize:NO];
    [button setImage:[UIImage imageNamed:@"button_bg_rot.png"]];
    assertThat(button.subviews, hasCountOf(1));
    
    button.enabled = NO;
    assertThatBool(button.enabled, equalToBool(NO));
    assertThatBool(((AMLabel*)(button.subviews.lastObject)).enabled, equalToBool(NO));
    assertThat(button.backgroundColor, equalTo([UIColor backgroundColor]));
    [self checkRoundedCornersView:button borderWidth:3.0f];
    
    button.enabled = YES;
    assertThatBool(button.enabled, equalToBool(YES));
    assertThatBool(((AMLabel*)(button.subviews.lastObject)).enabled, equalToBool(YES));
    assertThat(button.backgroundColor, equalTo([UIColor clearColor]));
    assertThatFloat(button.layer.cornerRadius, equalToFloat(0.0f));
    assertThatBool(button.layer.masksToBounds, equalToBool(NO));
    assertThatFloat(button.layer.borderWidth, equalToFloat(0.0f));
}

@end
