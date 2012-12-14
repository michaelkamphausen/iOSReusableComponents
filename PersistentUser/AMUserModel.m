//
//  AMUserModel.m
//  appic
//
//  Created by Michael Kamphausen on 02.10.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "AMUserModel.h"

@implementation AMUserModel

NSString* filepath;

+ (AMUserModel*)currentUser
{
    filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"AMUserModel"];
    static AMUserModel *currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
        if (!currentUser) {
            currentUser = [[AMUserModel alloc] init];
        }
    });
    return currentUser;
}

- (id)init
{
    self = [super init];
    if (!self) return self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save:) name:UIApplicationWillResignActiveNotification object:nil];
    
    return self;
}

- (AMUserModel*)loginWithIdentifier:(NSString*)identifier token:(NSString*)token
{
    if (!_isLoggedIn && identifier && token) {
        _identifier = identifier;
        _token = token;
        _isLoggedIn = YES;
    }
    return self;
}

- (void)save:(NSNotification*)notification
{
    if (![NSKeyedArchiver archiveRootObject:[AMUserModel currentUser] toFile:filepath]) {
        NSLog(@"error saving AMUserModel to %@", filepath);
    }
}

- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:[NSNumber numberWithBool:_isLoggedIn] forKey:@"isLoggedIn"];
    [coder encodeObject:_identifier forKey:@"identifier"];
    [coder encodeObject:_token forKey:@"token"];
    [coder encodeObject:_pushAlias forKey:@"pushAlias"];
}

- (id)initWithCoder:(NSCoder*)coder {
    self = [self init];
    if (!self) return self;
    
    _isLoggedIn = [[coder decodeObjectForKey:@"isLoggedIn"] boolValue];
    _identifier = [coder decodeObjectForKey:@"identifier"];
    _token = [coder decodeObjectForKey:@"token"];
    _pushAlias = [coder decodeObjectForKey:@"pushAlias"];
    return self;
}

@end
