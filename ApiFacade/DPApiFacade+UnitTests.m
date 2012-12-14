//
//  DPApiFacade+UnitTests.m
//  dings
//
//  Created by Michael Kamphausen on 15.11.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "DPApiFacade+UnitTests.h"
#import "NSObject+SupersequentImplementation.h"
#import <OCMock/OCMock.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

static DPApiFacade* mockApiFacade = nil;

@implementation DPApiFacade (UnitTests)

+ (DPApiFacade*)sharedInstance {
    if (mockApiFacade) {
        return mockApiFacade;
    }
    return invokeSupersequentNoParameters();
}

+ (id)createNiceMockObject {
    mockApiFacade = [OCMockObject niceMockForClass:[DPApiFacade class]];
    return mockApiFacade;
}

+ (void)destroyMockObject {
    mockApiFacade = nil;
}

@end

#pragma clang diagnostic pop
