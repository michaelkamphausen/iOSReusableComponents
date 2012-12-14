//
//  AMLoadingViewControllerTests.m
//  appic
//
//  Created by Michael Kamphausen on 25.10.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "AMLoadingViewControllerTests.h"
#import "AMAppDelegate.h"

@implementation AMLoadingViewControllerTests

- (void)setUp
{
    [super setUp];
    viewController = (AMLoadingViewController*)[self setUpViewControllerWithIdentifier:@"LoadingScene"];
    assertThat(viewController, notNilValue());
}

- (void)tearDown
{
    [self tearDownViewController];
    viewController = nil;
    [super tearDown];
}

- (void) testViewDidLoad
{
    assertThat(viewController.eyecatcher, notNilValue());
    assertThatFloat(viewController.eyecatcher.layer.cornerRadius, equalToFloat(10.));
    assertThatBool(viewController.eyecatcher.layer.masksToBounds, equalToBool(YES));
    assertThatFloat(viewController.eyecatcher.layer.borderWidth, equalToFloat(2.));
}

- (void) testUpdateViewConstraints
{
    assertThatBool(view.translatesAutoresizingMaskIntoConstraints, equalToBool(NO));
    assertThatFloat(view.center.x, equalToFloat(view.superview.center.x));
    assertThatFloat(view.center.y, equalToFloat(view.superview.center.y - 20.));
    assertThatFloat(view.frame.size.width, equalToFloat(300.));
    assertThatFloat(view.frame.size.height, equalToFloat(300.));
}

@end
