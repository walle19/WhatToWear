//
//  TodaysDressViewController.h
//  fbDemo
//
//  Created by Nikhil Wali on 22/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"
#import "DressCollectionViewCell.h"

@interface TodaysDressViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, DressDelegate>

@property (nonatomic, strong) User *user;

@end