//
//  DSAppDelegateTests.m
//  dings
//
//  Created by Carola Nitz on 11/9/12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "DSAppDelegateTests.h"
#import "UIColor+CustomColors.h"

@implementation DSAppDelegateTests

- (void)setUp
{
    [super setUp];
    appdelegate = [[DSAppDelegate alloc] init];
    assertThat(appdelegate, notNilValue());
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testApplicationDidFinishLaunchingWithOptions
{
    __block BOOL verifyTakeOff = NO;
    __block typeof(self) bSelf = self;
    [UAirship expectTakeOff:^(NSDictionary *options) {
        assertThat(options, notNilValue());
        assertThat(options, hasKey(UAirshipTakeOffOptionsAirshipConfigKey));
        NSDictionary *config = options[UAirshipTakeOffOptionsAirshipConfigKey];
        [bSelf checkKey:@"DEVELOPMENT_APP_KEY" inAirshipConfig:config];
        [bSelf checkKey:@"DEVELOPMENT_APP_SECRET" inAirshipConfig:config];
        [bSelf checkKey:@"PRODUCTION_APP_KEY" inAirshipConfig:config];
        [bSelf checkKey:@"PRODUCTION_APP_SECRET" inAirshipConfig:config];
        assertThat(config, hasKey(@"APP_STORE_OR_AD_HOC_BUILD"));
        assertThat(config[@"APP_STORE_OR_AD_HOC_BUILD"],
#ifdef TESTING
        equalTo(@"NO"));
#else
        equalTo(@"YES"));
#endif
        verifyTakeOff = YES;
    }];
    [self checkPreparePushNotificationCenterReset:NO usingBlock:^(id mockApplication) {
        [appdelegate application:mockApplication didFinishLaunchingWithOptions:nil];
    }];
    assertThatBool(verifyTakeOff, equalToBool(YES));
    assertThat(appdelegate.window, notNilValue());
    assertThat(appdelegate.window.backgroundColor, equalTo([UIColor blackColor]));
    assertThatBool(appdelegate.window.keyWindow, equalToBool(YES));
    assertThat(appdelegate.window.rootViewController, notNilValue());

}

- (void)testAppearanceCutomization
{
    
}

- (void)checkKey:(NSString*)key inAirshipConfig:(NSDictionary*)config
{
    assertThat(config, hasKey(key));
    assertThatInt(((NSString*)config[key]).length, equalToInt(22));
}


- (void)testApplicationWillResignActive
{
    [appdelegate applicationWillResignActive:[UIApplication sharedApplication]];
}

- (void)testApplicationDidEnterBackground
{
    [appdelegate applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)testApplicationWillEnterForeground
{
    [self checkPreparePushNotificationCenterReset:NO usingBlock:^(id mockApplication) {
        [appdelegate applicationWillEnterForeground:mockApplication];
    }];
    [self checkPreparePushNotificationCenterReset:YES usingBlock:^(id mockApplication) {
        [appdelegate applicationWillEnterForeground:mockApplication];
    }];
}

- (void)checkPreparePushNotificationCenterReset:(BOOL)hasBadge usingBlock:(void (^)(id mockApplication))testedMethod
{
    id mockApplication = [OCMockObject mockForClass:[UIApplication class]];
    [[[mockApplication expect] andReturnValue:OCMOCK_VALUE((int){hasBadge ? 2 : 0})] applicationIconBadgeNumber];
    if (!hasBadge) {
        [[mockApplication expect] setApplicationIconBadgeNumber:1];
    }
    testedMethod(mockApplication);
    STAssertNoThrow([mockApplication verify], nil);
}

- (void)testApplicationDidBecomeActive
{
    id mockApplication = [OCMockObject mockForClass:[UIApplication class]];
    [[mockApplication expect] setApplicationIconBadgeNumber:0];
    [appdelegate applicationDidBecomeActive:mockApplication];
    STAssertNoThrow([mockApplication verify], nil);
}

- (void)testApplicationWillTerminate
{
    __block BOOL verifyLand = NO;
    [UAirship expectLand:^{
        verifyLand = YES;
    }];
    [appdelegate applicationWillTerminate:[UIApplication sharedApplication]];
    assertThatBool(verifyLand, equalToBool(YES));
}

@end
