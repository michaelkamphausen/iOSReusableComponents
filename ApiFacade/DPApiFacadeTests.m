//
//  DSRestKitTests.m
//  dings
//
//  Created by Michael Kamphausen on 08.11.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "DPApiFacadeTests.h"
#import "DSAppDelegate.h"

@implementation DPApiFacadeTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSharedInstance {
    assertThat([DPApiFacade sharedInstance], notNilValue());
    assertThat([DPApiFacade sharedInstance], sameInstance([DPApiFacade sharedInstance]));
}

- (void)testInit {
    assertThat([DPApiFacade sharedInstance], notNilValue());
    assertThat([DPApiFacade sharedInstance].appDelegate, sameInstance([UIApplication sharedApplication].delegate));
    RKObjectManager* realObjectManager = [RKObjectManager realSharedManager];
    assertThat(realObjectManager, notNilValue());
    assertThat(realObjectManager.baseURL, notNilValue());
    assertThat(realObjectManager.objectStore, notNilValue());
    assertThat(realObjectManager.acceptMIMEType, equalTo(RKMIMETypeJSON));
    assertThat(realObjectManager.serializationMIMEType, equalTo(RKMIMETypeFormURLEncoded));
    assertThat(realObjectManager.client, notNilValue());
    assertThat(realObjectManager.client.HTTPHeaders, allOf(hasKey(@"Accept"), hasKey(@"Accept-Language"), hasKey(@"Content-Type"), hasKey(@"User-Agent"), nil));
    assertThat([realObjectManager.mappingProvider objectMappingForKeyPath:@"user"], notNilValue());
    assertThat([realObjectManager.mappingProvider objectMappingForKeyPath:@"region"], notNilValue());
    
    id mockNotificationCenter = [NSNotificationCenter createPartialMockObject];
    [[mockNotificationCenter expect] addObserver:[OCMArg isNotNil] selector:NSSelectorFromString(@"sessionStateChanged:") name:FBSessionStateChangedNotification object:[OCMArg isNil]];
    assertThat([[DPApiFacade alloc] init], notNilValue());
    STAssertNoThrow([mockNotificationCenter verify], nil);
    [NSNotificationCenter destroyMockObject];
}

- (void)testLogin {
    id mockAppDelegate = [OCMockObject mockForClass:[DSAppDelegate class]];
    [[mockAppDelegate expect] openSessionWithAllowLoginUI:YES];
    [DPApiFacade sharedInstance].appDelegate = mockAppDelegate;
    id mockFBSession = [FBSession createMockObject];
    [[[mockFBSession expect] andReturnValue:OCMOCK_VALUE((BOOL){NO})] isOpen];
    __block BOOL wasBlock1Called = NO;
    
    [[DPApiFacade sharedInstance] login:^(BOOL success, NSString *message) {
        wasBlock1Called = YES;
        assertThatBool(success, equalToBool(NO));
        assertThat(message, nilValue());
    }];
    STAssertNoThrow([mockAppDelegate verify], nil);
    [[DPApiFacade sharedInstance] sessionStateChanged:[NSNotification notificationWithName:FBSessionStateChangedNotification object:mockFBSession]];
    assertThatBool(wasBlock1Called, equalToBool(YES));
    STAssertNoThrow([mockFBSession verify], nil);
    
    //NSString* token = @"aksjdhfg";
    mockAppDelegate = [OCMockObject mockForClass:[DSAppDelegate class]];
    [[mockAppDelegate expect] openSessionWithAllowLoginUI:YES];
    [DPApiFacade sharedInstance].appDelegate = mockAppDelegate;
    mockFBSession = [FBSession createMockObject];
    [[[mockFBSession expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isOpen];
    //[[[mockFBSession expect] andReturn:token] accessToken];
    id mockRKObjectManager = [RKObjectManager createNiceMockObject];
    // ToDo: test block and uncomment above and below lines
    [[mockRKObjectManager expect] loadObjectsAtResourcePath:kApiLoginURL usingBlock:[OCMArg isNotNil]];
    __block BOOL wasBlock2Called = NO;
    
    [[DPApiFacade sharedInstance] login:^(BOOL success, NSString *message) {
        wasBlock2Called = YES;
        assertThatBool(success, equalToBool(YES));
        assertThat(message, nilValue());
    }];
    STAssertNoThrow([mockAppDelegate verify], nil);
    [[DPApiFacade sharedInstance] sessionStateChanged:[NSNotification notificationWithName:FBSessionStateChangedNotification object:mockFBSession]];
    //assertThatBool(wasBlock2Called, equalToBool(YES));
    STAssertNoThrow([mockFBSession verify], nil);
    STAssertNoThrow([mockRKObjectManager verify], nil);
    //assertThatBool([[DPApiFacade sharedInstance] isLoggedIn], equalToBool(YES));
}

- (void)testLogout {
    id mockFBSession = [FBSession createMockObject];
    [[[mockFBSession expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isOpen];
    id mockRKObjectManager = [RKObjectManager createNiceMockObject];
    [[mockRKObjectManager expect] client];
    id mockAppDelegate = [OCMockObject mockForClass:[DSAppDelegate class]];
    [[mockAppDelegate expect] closeSession];
    [DPApiFacade sharedInstance].appDelegate = mockAppDelegate;
    
    [[DPApiFacade sharedInstance] logout];
    // ToDo: test that existing me has been deleted
    assertThat([DPApiFacade sharedInstance].me, nilValue());
    // ToDo: test removal of HTTPHeader
    STAssertNoThrow([mockAppDelegate verify], nil);
    STAssertNoThrow([mockRKObjectManager verify], nil);
    STAssertNoThrow([mockFBSession verify], nil);
}

@end
