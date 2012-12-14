//
//  AppDelegate.h
//  dings
//
//  Created by Michael Kamphausen on 30.08.12.
//  Copyright (c) 2012 Michael Kamphausen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UAirship.h"
#import "UAPush.h"

@interface DSAppDelegate : UIResponder <UIApplicationDelegate>

extern NSString *const FBSessionStateChangedNotification;

@property (strong, nonatomic) UIWindow *window;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)closeSession;

@end
