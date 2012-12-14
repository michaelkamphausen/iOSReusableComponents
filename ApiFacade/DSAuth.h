//
//  DSAuth.h
//  dings
//
//  Created by Michael Kamphausen on 29.11.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSUser;

@interface DSAuth : NSManagedObject

@property (nonatomic, retain) NSString * device_id;
@property (nonatomic, retain) NSNumber * aid;
@property (nonatomic, retain) NSDate * last_login;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) DSUser *user;

@end
