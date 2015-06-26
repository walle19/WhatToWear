//
//  SignUpViewController.m
//  fbDemo
//
//  Created by Nikhil Wali on 20/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"

NSString * const FIRST_NAME_KEY = @"firstName";
NSString * const LAST_NAME_KEY = @"lastName";
NSString * const USERNAME_KEY = @"username";
NSString * const PASSWORD_KEY = @"password";

NSString * const SUCCESSFULLY_REGISTERED_USER_TEXT = @"Your successfully registered";
NSString * const ALREADY_REGISTERED_USER_TEXT = @"User already registered";

@interface SignUpViewController () <UITextFieldDelegate, UIAlertViewDelegate> {
    
    UITapGestureRecognizer *_tapGesture;
    
    BOOL _isValidUser;
    
}

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTextField;

@property (nonatomic, weak) IBOutlet UIButton *registerbutton;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation SignUpViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //To dismiss the keyboard on tap on view.
    [self addTapGesture];
    
    //Reset forme to default values
    [self resetForm];
    
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
    
    if (self.firstNameTextField.text.length != 0 && self.lastNameTextField.text.length != 0 && self.usernameTextField.text.length != 0 && self.passwordTextField.text.length != 0) {
        
        return NO;
        
    }
    
    return YES;
    
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.firstNameTextField == textField) {
        
        [self.firstNameTextField resignFirstResponder];
        [self.lastNameTextField becomeFirstResponder];
        
    }
    else if (self.lastNameTextField == textField) {
        
        [self.lastNameTextField resignFirstResponder];
        [self.usernameTextField becomeFirstResponder];
        
    }
    else if (self.usernameTextField == textField) {
        
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
        
    }
    else if (self.passwordTextField == textField) {
        
        [self.passwordTextField resignFirstResponder];
        
        [self registerNewUser:nil];
        
    }
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([self isAnyFieldEmpty]) {
        
        self.registerbutton.enabled = NO;
        
        return;
    }
    
    self.registerbutton.enabled = YES;
    
}

#pragma mark - IBAction Methods

- (IBAction)registerNewUser:(id)sender {
    
    if (![self isUserAvailable]) {
    
        _isValidUser = NO;
        
        [Utility showAlertWithTitle:ALERT_TITLE_KEY message:ALREADY_REGISTERED_USER_TEXT controller:self completionBlock:^(UIAlertAction *action) {
            
            NSLog(@"Ok action");
            
        }];
        
        return;
        
    }
    
    NSError *error;
    NSDictionary *userDetails = @{FIRST_NAME_KEY:self.firstNameTextField.text, LAST_NAME_KEY:self.lastNameTextField.text, USERNAME_KEY:self.usernameTextField.text, PASSWORD_KEY:self.passwordTextField.text};

    if (![self saveUserCredentialWithDetails:userDetails error:error]) {
        
        _isValidUser = NO;
        
        //error alert
        [Utility showAlertWithTitle:ALERT_TITLE_KEY message:error.localizedDescription controller:self completionBlock:^(UIAlertAction *action) {
            
            NSLog(@"Ok action");
            
        }];
        
    }
    else {
        
        _isValidUser = YES;

        //success alert
        [Utility showAlertWithTitle:ALERT_TITLE_KEY message:SUCCESSFULLY_REGISTERED_USER_TEXT controller:self completionBlock:^(UIAlertAction *action) {
            
            NSLog(@"Ok action");
            
            [self resetForm];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
    }
    
}

- (void)resetForm {
    
    self.firstNameTextField.text = @"";
    self.lastNameTextField.text = @"";
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";

    self.registerbutton.enabled = NO;

}

#pragma mark - DataBase Method

- (BOOL)isUserAvailable {
    
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
        
        //invalid user alert
        return YES;
        
    }
    
    return NO;

}

- (BOOL)saveUserCredentialWithDetails:(NSDictionary *)userDetails error:(NSError *)error {
    
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    
    NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:USER_ENTTY inManagedObjectContext:context];
    
    [user setValue: userDetails[FIRST_NAME_KEY] forKey:FIRST_NAME_KEY];
    [user setValue: userDetails[LAST_NAME_KEY] forKey:LAST_NAME_KEY];
    [user setValue: userDetails[USERNAME_KEY] forKey:USERNAME_KEY];
    [user setValue: userDetails[PASSWORD_KEY] forKey:PASSWORD_KEY];
    
    if (![context save:&error]) {

        return NO;
        
    }
    else {
        
        return YES;
        
    }
    
}

@end