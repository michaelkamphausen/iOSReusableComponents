//
//  AppDelegate.m
//  dings
//
//  Created by Michael Kamphausen on 30.08.12.
//  Copyright (c) 2012 Michael Kamphausen. All rights reserved.
//

#import "DSAppDelegate.h"
#import "UIColor+CustomColors.h"

@implementation DSAppDelegate

NSString *const FBSessionStateChangedNotification = @"dings:FBSessionStateChangedNotification";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    UIStoryboard *dingsStoryboard = [UIStoryboard storyboardWithName:@"dings-iphone" bundle:nil];
    self.window.rootViewController = [dingsStoryboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
    [self preparePushNotificationCenterReset:application];
    [self appearanceCutomization];
    [self setupUrbanAirship:launchOptions];
    
    [TestFlight takeOff:@""];
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
#endif
    [[UAPush shared]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)];
    return YES;
}

- (void)setupUrbanAirship:(NSDictionary*)launchOptions
{
    NSMutableDictionary *takeOffOptions = [[NSMutableDictionary alloc] init];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    [takeOffOptions setValue:@{
     @"DEVELOPMENT_APP_KEY": @"",
     @"DEVELOPMENT_APP_SECRET": @"",
     @"PRODUCTION_APP_KEY": @"",
     @"PRODUCTION_APP_SECRET": @"",
#ifdef TESTING
     @"APP_STORE_OR_AD_HOC_BUILD": @"NO"
#else
     @"APP_STORE_OR_AD_HOC_BUILD": @"YES"
#endif
     } forKey:UAirshipTakeOffOptionsAirshipConfigKey];
    
     [UAirship takeOff:takeOffOptions];
}

- (void)preparePushNotificationCenterReset:(UIApplication*)application
{
    if (application.applicationIconBadgeNumber == 0) {
        application.applicationIconBadgeNumber = 1;
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)appearanceCutomization
{
    
}

/*
 * If we have a valid session at the time of openURL call, we handle Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:session];
    
    if (error) {
        NSString* title = @"Error";
        NSString* message = error.localizedDescription;
        if ([error.domain isEqualToString:@"com.facebook.sdk"]) {
            if (error.code == 2) {
                NSString* appDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
                title = NSLocalizedString(@"fbloginerrortitle", nil);
                message = [NSString stringWithFormat:NSLocalizedString(@"fbloginerrormessage", nil), appDisplayName];
            }
        }
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:title
                                  message:message
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray *permissions = @[@"email"];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session,
                                                         FBSessionState state,
                                                         NSError *error) {
                                         [self sessionStateChanged:session
                                                             state:state
                                                             error:error];
                                     }];
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self preparePushNotificationCenterReset:application];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // this means the user switched back to this app without completing a login in Safari/Facebook App
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        [FBSession.activeSession close]; // so we close our session and start over
    }
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [FBSession.activeSession close];
    [UAirship land];
}

@end
