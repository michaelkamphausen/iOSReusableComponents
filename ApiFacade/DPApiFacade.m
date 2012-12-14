//
//  DPApiFacade.m
//  dings
//
//  Created by Michael Kamphausen on 08.11.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "DPApiFacade.h"
#import "DSMockDataGenerator.h"

NSString *const DPApiLoginURL = @"/login";

@interface DPApiFacade () {
    DPApiFacadeBoolBlock _loginBlock;
    DSMockDataGenerator* _mockDataGenerator;
}

@end

@implementation DPApiFacade

+ (DPApiFacade*)sharedInstance {
    static DPApiFacade *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DPApiFacade alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (!self) return self;
    
    _loginBlock = nil;
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:FBSessionStateChangedNotification object:nil];
    
#ifdef TESTING
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
    [self registerDefaultsFromSettingsBundle];
    NSString *baseURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"appapiurl"];
#else
    NSString *baseURL = @"http://liveapi.example.com";
#endif
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:baseURL];
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    // preventing data version merging by manually retrieving the NSManagedObjectModel
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"dings" withExtension:@"momd"];
    NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"dings.sqlite" usingSeedDatabaseName:nil managedObjectModel:managedObjectModel delegate:nil];
    objectManager.acceptMIMEType = RKMIMETypeJSON;
    [objectManager.client.HTTPHeaders setObject:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"Accept-Language"];
    NSString* userAgent = [NSString stringWithFormat:@"%@ %@ (%@), iOS %@",
                           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                           [[UIDevice currentDevice] systemVersion]];
    [objectManager.client.HTTPHeaders setObject:userAgent forKey:@"User-Agent"];
    [objectManager.client.HTTPHeaders setObject:[NSString stringWithFormat:@"%@;charset=UTF-8", RKMIMETypeFormURLEncoded] forKey:@"Content-Type"];
    [RKObjectManager setSharedManager:objectManager];
    [self createMappings:objectManager];
    
    _mockDataGenerator = [[DSMockDataGenerator alloc] initWithManagedObjectContext:objectManager.objectStore.managedObjectContextForCurrentThread];
    
    _me = [DSUser objectWithPredicate:[NSPredicate predicateWithFormat:@"logged_in == %@", @YES]];
    [self setupHTTPAuthToken];
    
    return self;
}

- (void)createMappings:(RKObjectManager*)objectManager {
    RKManagedObjectStore* objectStore = objectManager.objectStore;
    RKObjectMappingProvider* mappingProvider = objectManager.mappingProvider;
    
    RKManagedObjectMapping *authMapping = [RKManagedObjectMapping mappingForEntityWithName:@"DSAuth" inManagedObjectStore:objectStore];
    RKManagedObjectMapping *userMapping = [RKManagedObjectMapping mappingForEntityWithName:@"DSUser" inManagedObjectStore:objectStore];
    RKManagedObjectMapping *userImageMapping = [RKManagedObjectMapping mappingForEntityWithName:@"DSUserImage" inManagedObjectStore:objectStore];
    
    [authMapping mapAttributes:@"device_id", @"token", @"last_login", nil];
    [authMapping mapKeyPathsToAttributes:@"id", @"aid", nil];
    authMapping.primaryKeyAttribute = @"aid";
    [authMapping hasOne:@"user" withMapping:userMapping];
    [mappingProvider setMapping:authMapping forKeyPath:@"auth"];
    
    [userMapping mapAttributes:@"firstname", @"lastname", @"mail", @"fb_id", @"fb_token", @"fb_data", @"registered", @"push_token", nil];
    [userMapping mapKeyPathsToAttributes:@"id", @"uid", nil];
    userMapping.primaryKeyAttribute = @"uid";
    /*[userMapping hasMany:@"authtokens" withMapping:authMapping];
    [userMapping hasMany:@"images" withMapping:userImageMapping];*/
    // break cyclic references when serializing
    [userMapping mapKeyPath:@"authtokens" toRelationship:@"authtokens" withMapping:authMapping serialize:NO];
    [userMapping mapKeyPath:@"images" toRelationship:@"images" withMapping:userImageMapping serialize:NO];
    userMapping.rootKeyPath = @"data";
    [mappingProvider setMapping:userMapping forKeyPath:@"user"];
    [mappingProvider setObjectMapping:userMapping forResourcePathPattern:DPApiLoginURL];
    [mappingProvider setObjectMapping:userMapping forResourcePathPattern:@"/users/:uid"];
    [mappingProvider setSerializationMapping:[userMapping inverseMapping] forClass:[DSUser class]];
    [objectManager.router routeClass:[DSUser class] toResourcePath:@"/users/:uid"];
    
    [userImageMapping mapAttributes:@"created", @"height", @"width", @"mimetype", @"name", nil];
    [userImageMapping mapKeyPathsToAttributes:@"id", @"userimg_id", nil];
    userImageMapping.primaryKeyAttribute = @"userimg_id";
    [userImageMapping hasOne:@"user" withMapping:userMapping];
    [mappingProvider setMapping:userImageMapping forKeyPath:@"userImage"];
}

- (void)login:(DPApiFacadeBoolBlock)callback {
    _loginBlock = callback;
    [self.appDelegate openSessionWithAllowLoginUI:YES];
}

- (void)logout {
    [_me deleteEntity];
    [_me.managedObjectStore save:nil];
    _me = nil;
    [self setupHTTPAuthToken];
    if (FBSession.activeSession.isOpen) {
        [self.appDelegate closeSession];
    }
}

// Backend ToDo: should send request GET /users/:uid/friends, answering with list of users, but is faked with sample users
- (void)getMyFriendsUsingThisAppWithBlock:(DPApiFacadeObjectsBlock)callback {
    callback([_mockDataGenerator getUsers:1 + arc4random() % 12]);
}

- (void)sessionStateChanged:(NSNotification*)notification {
    FBSession* session = notification.object;
    if (_loginBlock) {
        if (session.isOpen) {
            NSString* deviceToken = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:DPApiLoginURL usingBlock:^(RKObjectLoader *loader) {
                loader.method = RKRequestMethodPOST;
                NSDictionary* params = @{@"grant_type": @"urn:lede:params:oauth:grant-type:facebook", @"x_accessToken": session.accessToken, @"x_deviceId": deviceToken};
                loader.sourceObject = params;
                loader.serializationMapping = [RKObjectMapping serializationMapping];
                [loader.serializationMapping mapAttributesFromArray:[params allKeys]];
                loader.onDidFailWithError = ^(NSError *error) {
                    NSLog(@"error: %@", error);
                    NSLog(@"response: %@", loader.response.bodyAsString);
                    _loginBlock(NO, NSLocalizedString(@"apploginerror", nil));
                    _loginBlock = nil;
                };
                loader.onDidLoadObject = ^(DSUser* user) {
                    NSLog(@"\nJSON: %@\n", loader.response.bodyAsString);
                    user.logged_in = @YES;
                    NSError* error = nil;
                    if (![user.managedObjectContext save:&error]) {
                        NSLog(@"Error while saving me: %@", error);
                    }
                    _me = [DSUser objectWithPredicate:[NSPredicate predicateWithFormat:@"logged_in == %@", @YES]];
                    [self setupHTTPAuthToken];
                    
                    // Backend ToDo: should provide a 320px width user image from facebook, but is not implemented
                    // Backend ToDo: devapi does not return fb_id, so here is a fallback
                    if ([_me.fb_id intValue] < 0) {
                        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
                            _me.fb_id = [numberFormatter numberFromString:result[@"id"]];
                            [self getProfileImage];
                        }];
                    } else {
                        [self getProfileImage];
                    }
                    
                    _loginBlock(_me != nil, nil);
                    _loginBlock = nil;
                };
            }];
        } else {
            _loginBlock(NO, nil);
            _loginBlock = nil;
        }
    }
}

// Backend ToDo: should provide a 320px width user image from facebook, but is not implemented
- (void)getProfileImage {
    DSUserImage* myImage = [DSUserImage object];
    myImage.name = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=320", _me.fb_id];
    [_me addImagesObject:myImage];
    [_me.managedObjectStore save:nil];
}

- (void)setupHTTPAuthToken {
    if (_me) {
        NSString* deviceToken = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSSet* authTokensWithDeviceId = [_me.authtokens filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"device_id == %@", deviceToken]];
        NSManagedObject* authToken = [[authTokensWithDeviceId filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"aid == %@.@max.aid", authTokensWithDeviceId]] anyObject];
        [[RKObjectManager sharedManager].client.HTTPHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [authToken valueForKey:@"token"]] forKey:@"Authorization"];
    } else {
        [[RKObjectManager sharedManager].client.HTTPHeaders removeObjectForKey:@"Authorization"];
    }
}

- (RKObjectLoaderBlock)getBlockWithCallback:(DPApiFacadeObjectsBlock)callback {
    return ^(RKObjectLoader *loader) {
        [self setupErrorLoggingForLoader:loader];
        loader.onDidLoadObjects = ^(NSArray* objects) {
            NSLog(@"================");
            NSLog(@"Request: %@ %@", loader.HTTPMethod, loader.resourcePath);
            NSLog(@"Response: %@", loader.response.bodyAsString);
            NSLog(@"Success");
            NSLog(@"================");
            callback(objects);
        };
    };
}

- (void)setupErrorLoggingForLoader:(RKObjectLoader*)loader {
    loader.onDidFailWithError = ^(NSError *error) {
        NSLog(@"================");
        NSLog(@"Request: %@ %@", loader.HTTPMethod, loader.resourcePath);
        NSLog(@"Response: %@", loader.response.bodyAsString);
        NSLog(@"Error: %@\n", error);
        NSLog(@"================");
    };
}

#ifdef TESTING

- (void)defaultsChanged:(NSNotification*)notification {
    [RKClient sharedClient].baseURL = [RKURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"appapiurl"]];
}

- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = settings[@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for (NSDictionary *preference in preferences) {
        NSString *key = preference[@"Key"];
        if (key) {
            [defaultsToRegister setObject:preference[@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}

#endif

@end
