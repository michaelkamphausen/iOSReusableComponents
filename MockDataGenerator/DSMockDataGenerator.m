//
//  DSMockDataGenerator.m
//  dings
//
//  Created by Michael Kamphausen on 06.12.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "DSMockDataGenerator.h"
#import "DSAuth.h"
#import "DSUser.h"
#import "DSUserImage.h"

static NSArray* DSFirstNames;
static NSArray* DSLastNames;

@implementation DSMockDataGenerator

- (NSString*)firstname {
    if (!DSFirstNames) {
        DSFirstNames = @[@"Julia", @"Steffi", @"Anna", @"Katharina", @"Katrin", @"Christian", @"Sebastian", @"Jan", @"Daniel", @"Stefan"];
    }
    return DSFirstNames[arc4random() % DSFirstNames.count];
}

- (NSString*)lastname {
    if (!DSLastNames) {
        DSLastNames = @[@"Müller", @"Schmidt", @"Schneider", @"Fischer", @"Weber", @"Meyer", @"Wagner", @"Becker", @"Schulz", @"Hoffmann"];
    }
    return DSLastNames[arc4random() % DSLastNames.count];
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)context {
    self = [super init];
    if (!self) return nil;
    
    _managedObjectContext = context;
    return self;
}

- (NSArray*)getUsers:(NSUInteger)count {
    return [self getManagedObjects:count forClass:[DSUser class] withBlock:^(DSUser *user) {
        user.firstname = [self firstname];
        user.lastname = [self lastname];
        user.mail = [NSString stringWithFormat:@"%@.%@@example.com", user.firstname, user.lastname, nil];
        user.registered = [NSDate date];
        [user addImagesObject:[self getUserImage]];
    }];
}

- (NSArray*)getAuths:(NSUInteger)count {
    return [self getManagedObjects:count forClass:[DSAuth class] withBlock:^(DSAuth *auth) {
    }];
}

- (NSArray*)getManagedObjects:(NSUInteger)count forClass:(Class)classname withBlock:(void (^)(id object))customize {
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:NSStringFromClass(classname) inManagedObjectContext:self.managedObjectContext];
    NSMutableArray* objects = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSManagedObject* object = [[classname alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        customize(object);
        [objects addObject:object];
    }
    return [NSArray arrayWithArray:objects];
}

- (DSUserImage*)getUserImage {
    return (DSUserImage*)[self getImageForClass:[DSUserImage class] withURL:@"http://placekitten.com" width:(320 + arc4random() % 200) height:(320 + arc4random() % 200)];
}

- (DSImage*)getImageForClass:(Class)classname withURL:(NSString*)baseURL width:(int)width height:(int)height {
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:NSStringFromClass(classname) inManagedObjectContext:self.managedObjectContext];
    DSImage* image = [[classname alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    NSString* maybeGray = (arc4random() % 4 > 0) ? @"" : @"/g";
    image.name = [NSString stringWithFormat:@"%@%@/%i/%i", baseURL, maybeGray, width, height, nil];
    image.width = [NSNumber numberWithInt:width];
    image.height = [NSNumber numberWithInt:height];
    image.mimetype = @"image/jpeg";
    image.created = [NSDate date];
    return image;
}

@end
