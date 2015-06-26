//
//  LoginViewController.m
//  fbDemo
//
//  Created by Nikhil Wali on 20/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

NSString * const INVALID_USER_TEXT = @"Invalid user";

NSString * const HOME_VIEW_ID = @"HomeView";

@interface LoginViewController ()<UITextFieldDelegate> {
    
    UITapGestureRecognizer *_tapGesture;
    
}

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) HomeViewController *homeViewController;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) User *user;

@end

@implementation LoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];
    
    //To dismiss the keyboard on tap on view.
    [self addTapGesture];
    
    [self clearFields];
    
    self.appDelegate = [Utility appDelegateInstance];

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}

#pragma mark - Business Logic

- (void)addTapGesture {
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:_tapGesture];
    
}

- (void)dismissKeyboard {
    
    [self.view endEditing:YES];
    
}

- (BOOL)isAnyFieldEmpty {
    
    if (self.usernameTextField.text.length != 0 && self.passwordTextField.text.length != 0) {
        
        return NO;
        
    }
    
    return YES;
    
}

- (void)clearFields {
    
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
    
    self.loginButton.enabled = NO;
    
}

- (void)showHomeView {
    
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:MAIN_STORYBOARD bundle:nil];
    self.homeViewController = [myStoryboard instantiateViewControllerWithIdentifier:HOME_VIEW_ID];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.usernameTextField == textField) {
        
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
        
    }
    else if (self.passwordTextField == textField) {
        
        [self.passwordTextField resignFirstResponder];
        
        [self login:nil];
        
    }
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([self isAnyFieldEmpty]) {
        
        self.loginButton.enabled = NO;
        
        return;
    }
    
    self.loginButton.enabled = YES;
    
}

#pragma mark - IBAction Methods

- (IBAction)login:(id)sender {
    
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:USER_ENTTY inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(username = %@ && password = %@)", self.usernameTextField.text, self.passwordTextField.text];
    request.predicate = predicate;
    request.fetchLimit = 1;
    
    NSError *error;
    NSArray *users = [context executeFetchRequest:request error:&error];
    
    if (!users.count) {
        
        //Invalid user alert
        [Utility showAlertWithTitle:ALERT_TITLE_KEY message:INVALID_USER_TEXT controller:self completionBlock:^(UIAlertAction *action) {

            NSLog(@"Ok action");

        }];
        
        return;
        
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.usernameTextField.text forKey:NORMAL_LOGIN_KEY];
    
    self.user = (User *)users.firstObject;

    [self showHomeView];
    
}

@end
