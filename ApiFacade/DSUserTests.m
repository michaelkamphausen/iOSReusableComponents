//
//  DSUserTests.m
//  dings
//
//  Created by Michael Kamphausen on 05.12.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "DSUserTests.h"

@implementation DSUserTests

- (void)setUp {
    [super setUp];
    user = (DSUser*)([self.mockDataGenerator getUsers:1][0]);
}

- (void)tearDown {
    user = nil;
    [super tearDown];
}

- (void)testFullname {
    assertThat(user.fullname, equalTo([NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname]));
}

@end
