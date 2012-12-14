//
//  DSUserImage.h
//  dings
//
//  Created by Michael Kamphausen on 29.11.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DSImage.h"

@class DSUser;

@interface DSUserImage : DSImage

@property (nonatomic, retain) NSNumber * userimg_id;
@property (nonatomic, retain) DSUser *user;

@end
