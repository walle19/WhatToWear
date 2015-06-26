//
//  HomeViewController.m
//  fbDemo
//
//  Created by Nikhil Wali on 21/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "HomeViewController.h"
#import "BookMarkViewController.h"
#import "ProfileViewController.h"
#import "AddMoreViewController.h"
#import "TodaysDressViewController.h"

NSString * const PROFILE_SEGUE_ID = @"profileSegue";
NSString * const TODAY_DRESS_SEGUE_ID = @"todayDressSegue";
NSString * const ADD_MORE_SEGUE_ID = @"addMoreSegue";
NSString * const BOOKMARK_SEGUE_ID = @"bookMarkSegue";

NSString * const ADD_MORE_VIEW_ID = @"AddMoreView";

NSString * const LOGOUT_IMAGE_NAME = @"logout";

@interface HomeViewController ()

@property (nonatomic, strong) BookMarkViewController *bookMarkViewController;

@property (nonatomic, strong) AddMoreViewController *addMoreViewController;

@property (nonatomic, strong) ProfileViewController *profileViewController;

@property (nonatomic, strong) TodaysDressViewController *todayDressViewController;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) User *user;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"What 2 Wear";
    
    [self addLogoutBarButton];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.user = [self getUser];
    
    [self checkFirstTimeUser];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Business Logic

- (User *)getUser {
    
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:USER_ENTTY inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:FB_TOKEN_KEY]) {
        
        predicate = [NSPredicate predicateWithFormat:@"username = %@", [defaults objectForKey:FB_TOKEN_KEY]];
   
    }
    else {
        
        predicate = [NSPredicate predicateWithFormat:@"username = %@", [defaults objectForKey:NORMAL_LOGIN_KEY]];
        
    }
    
    request.predicate = predicate;
    request.fetchLimit = 1;
    
    NSError *error;
    NSArray *users = [context executeFetchRequest:request error:&error];
    
    if (!users.count) {
        
        return nil;
        
    }
    
    return (User *)users.firstObject;

}

- (void)checkFirstTimeUser {
    
    if (!self.user.dresses.allObjects.count) {
    
        [self showAddMoreView];
        
    }
    
}

- (void)addLogoutBarButton {
    
    UIBarButtonItem *logoutBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:LOGOUT_IMAGE_NAME] style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
    self.navigationItem.rightBarButtonItems = @[logoutBarButtonItem];

}

- (void)logout {
 
    NSLog(@"Logout");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults objectForKey:FB_TOKEN_KEY];
    
    if (tokenString) {
        
        FBSDKLoginManager *logoutFromFB = [[FBSDKLoginManager alloc] init];
        [logoutFromFB logOut];
        
        [defaults removeObjectForKey:FB_TOKEN_KEY];
        
    }
    else {
     
        [defaults removeObjectForKey:NORMAL_LOGIN_KEY];

    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)showAddMoreView {
    
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:MAIN_STORYBOARD bundle:nil];
    self.addMoreViewController = [myStoryboard instantiateViewControllerWithIdentifier:ADD_MORE_VIEW_ID];
    self.addMoreViewController.user = self.user;
    
    [self.navigationController pushViewController:self.addMoreViewController animated:NO];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:PROFILE_SEGUE_ID]) {
        
        self.profileViewController = segue.destinationViewController;
        self.profileViewController.user = self.user;

    }
    else if ([segue.identifier isEqualToString:TODAY_DRESS_SEGUE_ID]) {
        
        self.todayDressViewController = segue.destinationViewController;
        self.todayDressViewController.user = self.user;
        
    }
    else if ([segue.identifier isEqualToString:ADD_MORE_SEGUE_ID]) {
        
        self.addMoreViewController = segue.destinationViewController;
        self.addMoreViewController.user = self.user;
    }
    else if ([segue.identifier isEqualToString:BOOKMARK_SEGUE_ID]) {
        
        self.bookMarkViewController = segue.destinationViewController;
        self.bookMarkViewController.user = self.user;

    }
    
}


@end
