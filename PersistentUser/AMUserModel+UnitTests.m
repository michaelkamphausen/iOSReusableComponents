//
//  AMUserModel+UnitTests.m
//  appic
//
//  Created by Michael Kamphausen on 10.10.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "AMUserModel+UnitTests.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

static AMUserModel* mockUserModel = nil;

@implementation AMUserModel (UnitTests)

+ (id)createMockObject
{
    mockUserModel = [OCMockObject niceMockForClass:[AMUserModel class]];
    return mockUserModel;
    
}

+ (AMUserModel *)currentUser
{
    if (mockUserModel) {
        return mockUserModel;
    }
    return invokeSupersequentNoParameters();
}

@end

#pragma clang diagnostic pop
