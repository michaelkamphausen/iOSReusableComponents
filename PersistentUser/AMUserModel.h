//
//  AMUserModel.h
//  appic
//
//  Created by Michael Kamphausen on 02.10.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMUserModel : NSObject <NSCoding>

@property (strong, nonatomic, readonly) NSString* identifier;
@property (strong, nonatomic, readonly) NSString* token;
@property (readonly) BOOL isLoggedIn;
@property (strong, nonatomic) NSString* pushAlias;

+ (AMUserModel*)currentUser;
- (AMUserModel*)loginWithIdentifier:(NSString*)id token:(NSString*)token;

- (void)encodeWithCoder:(NSCoder*)coder;
- (id)initWithCoder:(NSCoder*)coder;

@end
