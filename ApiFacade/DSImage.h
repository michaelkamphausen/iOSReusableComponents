//
//  DSImage.h
//  dings
//
//  Created by Michael Kamphausen on 29.11.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSImage : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * mimetype;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * width;

@end
