//
//  DPApiFacade+UnitTests.h
//  dings
//
//  Created by Michael Kamphausen on 15.11.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "DPApiFacade.h"

@interface DPApiFacade (UnitTests)

+ (DPApiFacade*)sharedInstance;

+ (id)createNiceMockObject;
+ (void)destroyMockObject;

@end
