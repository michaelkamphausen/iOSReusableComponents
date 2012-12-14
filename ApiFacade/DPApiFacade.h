//
//  DPApiFacade.h
//  dings
//
//  Created by Michael Kamphausen on 08.11.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "DSAppDelegate.h"
#import "DSUser+Customization.h"
#import "DSUserImage.h"
#import "DSAuth.h"

typedef void(^DPApiFacadeBoolBlock)(BOOL success, NSString* message);
typedef void(^DPApiFacadeObjectsBlock)(NSArray* objects);

extern NSString *const DPApiLoginURL;

@interface DPApiFacade : NSObject

+ (DPApiFacade*)sharedInstance;

- (void)login:(DPApiFacadeBoolBlock)callback;
- (void)logout;
- (void)getMyFriendsUsingThisAppWithBlock:(DPApiFacadeObjectsBlock)callback;

- (void)sessionStateChanged:(NSNotification*)notification;

@property (weak, nonatomic) DSAppDelegate* appDelegate;
@property (strong, nonatomic, readonly) DSUser* me;

@end
