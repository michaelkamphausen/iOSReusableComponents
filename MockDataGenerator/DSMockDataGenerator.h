//
//  DSMockDataGenerator.h
//  dings
//
//  Created by Michael Kamphausen on 06.12.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSMockDataGenerator : NSObject

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)context;
- (NSArray*)getUsers:(NSUInteger)count;
- (NSArray*)getAuths:(NSUInteger)count;

@property (strong, nonatomic, readonly) NSManagedObjectContext* managedObjectContext;

@end
