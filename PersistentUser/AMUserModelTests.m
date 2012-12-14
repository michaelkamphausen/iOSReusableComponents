//
//  AMUserModelTests.m
//  appic
//
//  Created by Michael Kamphausen on 02.10.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "AMUserModelTests.h"
#import <objc/runtime.h>

@implementation AMUserModelTests

- (void)setUp
{
    [super setUp];
    user = [[AMUserModel alloc] init];
    assertThat(user, notNilValue());
    assertThat(user.token, nilValue());
    assertThatBool(user.isLoggedIn, equalToBool(NO));
}

- (void)tearDown
{
    
    [super tearDown];
}

- (void)testCurrentUser
{
    assertThat([AMUserModel currentUser], notNilValue());
    assertThat([AMUserModel currentUser], sameInstance([AMUserModel currentUser]));
}

- (void)testUIApplicationWillResignActiveNotification
{
    Method originalMethod = class_getInstanceMethod([NSNotificationCenter class], @selector(addObserver:selector:name:object:));
    Method mockMethod = class_getInstanceMethod([self class], @selector(didAddObserver:selector:name:object:));
    method_exchangeImplementations(originalMethod, mockMethod);
    
    user = [[AMUserModel alloc] init];
    [self wait:0.01];
    
    assertThatBool([NSKeyedArchiver checkKeyedArchiverHasBeenCalled], equalToBool(YES));
    method_exchangeImplementations(mockMethod, originalMethod);
}

- (void)didAddObserver:(NSObject *)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
    if ([observer respondsToSelector:aSelector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [observer performSelector:aSelector withObject:nil afterDelay:0.0];
        #pragma clang diagnostic pop
    }
}

- (void)testLoginWithIdentifierToken
{
    NSString* identifier = @"54321";
    NSString* token = @"12345";
    [user loginWithIdentifier:identifier token:token];
    assertThatBool(user.isLoggedIn, equalToBool(YES));
    assertThat(user.token, equalTo(token));
    assertThat(user.identifier, equalTo(identifier));
    [user loginWithIdentifier:@"trewq" token:@"qwert"];
    assertThat(user.token, equalTo(token));
    assertThat(user.identifier, equalTo(identifier));
}

- (void)testEncodeWithCoder
{
    NSString* identifier = @"23456";
    NSString* token = @"65432";
    NSString* pushAlias = @"qwertz";
    [user loginWithIdentifier:identifier token:token];
    user.pushAlias = pushAlias;
    id mockCoder = [OCMockObject mockForClass:[NSCoder class]];
    [[mockCoder expect] encodeObject:[NSNumber numberWithBool:YES] forKey:@"isLoggedIn"];
    [[mockCoder expect] encodeObject:identifier forKey:@"identifier"];
    [[mockCoder expect] encodeObject:token forKey:@"token"];
    [[mockCoder expect] encodeObject:pushAlias forKey:@"pushAlias"];
    [user encodeWithCoder:mockCoder];
    
    STAssertNoThrow([mockCoder verify], nil);
}

- (void)testInitWithCoder
{
    NSString* identifier = @"76543";
    NSString* token = @"34567";
    NSString* pushAlias = @"asdfg";
    id mockCoder = [OCMockObject mockForClass:[NSCoder class]];
    [[[mockCoder expect] andReturn:[NSNumber numberWithBool:YES]] decodeObjectForKey:@"isLoggedIn"];
    [[[mockCoder expect] andReturn:identifier] decodeObjectForKey:@"identifier"];
    [[[mockCoder expect] andReturn:token] decodeObjectForKey:@"token"];
    [[[mockCoder expect] andReturn:pushAlias] decodeObjectForKey:@"pushAlias"];
    
    AMUserModel* newUser = [[AMUserModel alloc] initWithCoder:mockCoder];
    
    STAssertNoThrow([mockCoder verify], nil);
    assertThatBool(newUser.isLoggedIn, equalToBool(YES));
    assertThat(newUser.identifier, equalTo(identifier));
    assertThat(newUser.token, equalTo(token));
    assertThat(newUser.pushAlias, equalTo(pushAlias));
}

@end
