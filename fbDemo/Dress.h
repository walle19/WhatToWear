//
//  Dress.h
//  fbDemo
//
//  Created by Nikhil Wali on 22/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Dress : NSManagedObject

@property (nonatomic, strong) NSData *dressData;
@property (nonatomic, strong) NSNumber *isBookmarked;
@property (nonatomic, strong) User *user;

@end
