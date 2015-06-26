//
//  ProfileViewController.m
//  fbDemo
//
//  Created by Nikhil Wali on 22/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) IBOutlet UILabel *firstnameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastnameLabel;

@end

@implementation ProfileViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];
        
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self updateUIForDisplay];
    
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}

#pragma mark - Business Logic

- (void)updateUIForDisplay {

    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 2.5f;
    
    self.firstnameLabel.text = self.user.firstName;
    self.lastnameLabel.text = self.user.lastName;
    
}

@end
