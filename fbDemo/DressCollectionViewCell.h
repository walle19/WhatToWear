//
//  DressCollectionViewCell.h
//  fbDemo
//
//  Created by Nikhil Wali on 25/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DressDelegate <NSObject>

@required

- (void)bookmarkSelectedDress:(id)sender;

@optional

- (void)nextDressImage:(id)sender;

@end

@interface DressCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *dressImageView;

@property (nonatomic, weak) IBOutlet UIButton *bookmarkButton;

@property (nonatomic, weak) IBOutlet UIButton *dislikeButton;

@property (nonatomic, strong) id<DressDelegate> delegate;

@end
