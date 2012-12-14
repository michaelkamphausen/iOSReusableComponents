//
//  DSUser+Customization.m
//  dings
//
//  Created by Michael Kamphausen on 05.12.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "DSUser+Customization.h"

@implementation DSUser (Customization)

- (NSString*)fullname {
    return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname, nil];
}

@end
