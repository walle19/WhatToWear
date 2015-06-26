//
//  BookMarkViewController.h
//  fbDemo
//
//  Created by Nikhil Wali on 21/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"
#import "DressCollectionViewCell.h"

@interface BookMarkViewController : UIViewController <DressDelegate>

@property (nonatomic, strong) User *user;

@end
