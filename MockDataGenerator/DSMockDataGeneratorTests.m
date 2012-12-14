//
//  DSMockDataGeneratorTests.m
//  dings
//
//  Created by Michael Kamphausen on 10.12.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "DSMockDataGeneratorTests.h"

@implementation DSMockDataGeneratorTests

- (void)setUp {
    [super setUp];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"dings" withExtension:@"momd"];
    NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator* coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSManagedObjectContext* managedObjectContext = [[NSManagedObjectContext alloc] init];
    managedObjectContext.persistentStoreCoordinator = coordinator;
    mockDataGenerator = [[DSMockDataGenerator alloc] initWithManagedObjectContext:managedObjectContext];
    assertThat(mockDataGenerator, notNilValue());
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
    assertThat(mockDataGenerator.managedObjectContext, notNilValue());
}

- (void)testGetUsers {
    int count = 1 + arc4random() % 10;
    NSArray* users = [mockDataGenerator getUsers:count];
    DSUser* user = users[0];
    assertThat(users, hasCountOf(count));
    assertThat([user class], equalTo([DSUser class]));
    assertThat(user.managedObjectContext, equalTo(mockDataGenerator.managedObjectContext));
    assertThat(user.firstname, notNilValue());
    assertThat(user.lastname, notNilValue());
    assertThat(user.mail, notNilValue());
    assertThat(user.registered, notNilValue());
    assertThat(user.images, hasCountOf(1));
    DSUserImage* userImage = user.images.anyObject;
    assertThat(userImage.name, startsWith(@"http://placekitten.com"));
    assertThat(userImage.width, greaterThanOrEqualTo(@320));
    assertThat(userImage.height, greaterThanOrEqualTo(@320));
    assertThat(userImage.mimetype, equalTo(@"image/jpeg"));
    assertThat(userImage.created, notNilValue());
}

- (void)testGetAuths {
    int count = 1 + arc4random() % 10;
    NSArray* auths = [mockDataGenerator getAuths:count];
    DSAuth* auth = auths[0];
    assertThat(auths, hasCountOf(count));
    assertThat([auth class], equalTo([DSAuth class]));
    assertThat(auth.managedObjectContext, equalTo(mockDataGenerator.managedObjectContext));
}

@end
