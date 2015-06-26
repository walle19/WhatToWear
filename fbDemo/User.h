//
//  User.h
//  fbDemo
//
//  Created by Nikhil Wali on 22/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dress;

@interface User : NSManagedObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSSet *dresses;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addDressesObject:(Dress *)value;
- (void)removeDressesObject:(Dress *)value;
- (void)addDresses:(NSSet *)values;
- (void)removeDresses:(NSSet *)values;

@end
