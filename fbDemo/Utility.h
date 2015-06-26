//
//  Utility.h
//  fbDemo
//
//  Created by Nikhil Wali on 24/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

typedef void(^actionBlock)(UIAlertAction *);

@interface Utility : NSObject

+ (AppDelegate *)appDelegateInstance;

+ (void)showAlertWithTitle:(NSString *)titleString message:(NSString *)messageString controller:(id)sender completionBlock:(actionBlock)actionHandlerBlock;

@end
