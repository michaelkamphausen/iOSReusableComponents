//
//  AMErrorViewControllerTests.m
//  appic
//
//  Created by Michael Kamphausen on 25.10.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "AMErrorViewControllerTests.h"

@implementation AMErrorViewControllerTests

- (void)setUp
{
    [super setUp];
    viewController = (AMErrorViewController*)[self setUpViewControllerWithIdentifier:@"ErrorScene"];
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
    [self checkRoundedCornersView:viewController.eyecatcher borderWidth:2.0f];
    [self checkAMButton:viewController.reloadButton];
    assertThat([viewController.reloadButton actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside], hasItem(@"reload:"));
    assertThat(viewController.descriptionLabel, notNilValue());
}

- (void) testReload
{
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(AMErrorViewControllerDelegate)];
    [[mockDelegate expect] reloadAfterError:nil];
    viewController.delegate = mockDelegate;
    [viewController reload:nil];
    STAssertNoThrow([mockDelegate verify], nil);
}

- (void)testSetDefaultDescription
{
    NSString* description = viewController.descriptionLabel.text;
    viewController.descriptionLabel.text = @"42";
    [viewController setDefaultDescription];
    assertThat(viewController.descriptionLabel.text, equalTo(description));
}

@end
