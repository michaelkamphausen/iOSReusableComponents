//
//  DSUser.h
//  dings
//
//  Created by Michael Kamphausen on 30.11.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSAuth, DSUserImage;

@interface DSUser : NSManagedObject

@property (nonatomic, retain) NSString * fb_data;
@property (nonatomic, retain) NSNumber * fb_id;
@property (nonatomic, retain) NSString * fb_token;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSNumber * logged_in;
@property (nonatomic, retain) NSString * mail;
@property (nonatomic, retain) NSDate * registered;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * push_token;
@property (nonatomic, retain) NSSet *authtokens;
@property (nonatomic, retain) NSSet *images;
@end

@interface DSUser (CoreDataGeneratedAccessors)

- (void)addAuthtokensObject:(DSAuth *)value;
- (void)removeAuthtokensObject:(DSAuth *)value;
- (void)addAuthtokens:(NSSet *)values;
- (void)removeAuthtokens:(NSSet *)values;

- (void)addImagesObject:(DSUserImage *)value;
- (void)removeImagesObject:(DSUserImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
