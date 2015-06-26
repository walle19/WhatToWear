//
//  ViewController.m
//  fbDemo
//
//  Created by Nikhil Wali on 20/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "InitialViewController.h"
#import "HomeViewController.h"

NSString * const HOME_NIB_ID = @"HomeView";

NSString * const USER_ID_KEY = @"username";

@interface InitialViewController ()

@property (nonatomic, strong) HomeViewController *homeViewController;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) User *user;

@end

@implementation InitialViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.appDelegate = [Utility appDelegateInstance];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:FB_TOKEN_KEY]) {
        
        [self showHomeViewForFBLoginWithToken:[defaults objectForKey:FB_TOKEN_KEY]];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - IBAction method

- (IBAction)loginWithFacebook:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"email", @"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            
            // Process error
            NSLog(@"Error : %@", error.localizedDescription);
            
            [Utility showAlertWithTitle:ALERT_TITLE_KEY message:error.localizedDescription controller:self completionBlock:^(UIAlertAction *action) {
                
                NSLog(@"Ok action");
                
            }];

        }
        else if (result.isCancelled) {
            
            // Handle cancellations
            NSLog(@"Login canceled");
            
        }
        else {
    
            if ([result.grantedPermissions containsObject:@"email"]) {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:result.token.tokenString forKey:FB_TOKEN_KEY];
                
                [self showHomeViewForFBLoginWithToken:result.token.tokenString];
                
            }
            
        }
        
    }];
    
}

#pragma mark - business logic

- (void)showHomeViewForFBLoginWithToken:(NSString *)tokenString {
    
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:USER_ENTTY inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", tokenString];
    request.predicate = predicate;
    request.fetchLimit = 1;
    
    NSError *error;
    NSArray *users = [context executeFetchRequest:request error:&error];
    
    if (!users.count) {
        
        NSError *error;
        if (![self saveUserCredentialWithDetails:@{USER_ID_KEY: tokenString} error:error]) {
            
            NSLog(@"%@", error.localizedDescription);
            
        }
        
    }
    
    self.user = (User *)users.firstObject;
    
    [self showHomeView];
    
}

- (BOOL)saveUserCredentialWithDetails:(NSDictionary *)userDetails error:(NSError *)error {
    
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    
    NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:USER_ENTTY inManagedObjectContext:context];
    
    [user setValue: userDetails[USER_ID_KEY] forKey:USER_ID_KEY];
    
    if (![context save:&error]) {
        
        return NO;
        
    }
    
    return YES;
    
}

- (void)showHomeView {
    
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:MAIN_STORYBOARD bundle:nil];
    self.homeViewController = [myStoryboard instantiateViewControllerWithIdentifier:HOME_NIB_ID];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];

}

@end
