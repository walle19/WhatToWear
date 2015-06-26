//
//  Utility.m
//  fbDemo
//
//  Created by Nikhil Wali on 24/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import "Utility.h"
#import "User.h"

User *_user = nil;

static AppDelegate *_appDelegate = nil;

@implementation Utility

+ (AppDelegate *)appDelegateInstance {
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^ {
        
        _appDelegate = [UIApplication sharedApplication].delegate;
        
    });
    
    return _appDelegate;
    
}

+ (void)showAlertWithTitle:(NSString *)titleString message:(NSString *)messageString controller:(id)sender completionBlock:(actionBlock)actionHandlerBlock {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleString message:messageString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        actionHandlerBlock(action);
        
    }];
    
    [alertController addAction:okAction];
    
    [sender presentViewController:alertController animated:YES completion:nil];
    
}

@end
