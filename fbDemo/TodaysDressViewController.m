//
//  TodaysDressViewController.m
//  fbDemo
//
//  Created by Nikhil Wali on 22/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import <FBSDKShareKit/FBSDKShareKit.h>

#import "TodaysDressViewController.h"
#import "Dress.h"

NSString * const DRESS_CUSTOM_CELL_ID = @"dressCustomCell";

NSString * const BOOKMARKED_IMAGE = @"add_to_favorites_filled";
NSString * const UNBOOKMARKED_IMAGE = @"add_to_favorites";

@interface TodaysDressViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FBSDKSharingDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *dressCollectionView;

@property (nonatomic, strong) NSMutableArray *dresses;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, weak) IBOutlet UILabel *informationLabel;

@end

@implementation TodaysDressViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"User : %@", self.user);
    
    [self addShareBarButton];
    
    self.appDelegate = [Utility appDelegateInstance];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self updateCollectionView];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Business Logic

- (void)addShareBarButton {
    
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:SHARE_ICON] style:UIBarButtonItemStylePlain target:self action:@selector(shareDressImage)];
    
    self.navigationItem.rightBarButtonItems = @[shareBarButtonItem];
    
}

- (void)shareDressImage {
    
    DressCollectionViewCell *cell = self.dressCollectionView.visibleCells.firstObject;
    
    NSIndexPath *indexPath = [self.dressCollectionView indexPathForCell:cell];
    
    Dress *dress = self.dresses[(NSUInteger)indexPath.row];
    
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = [UIImage imageWithData:dress.dressData];
    
    photo.userGenerated = YES;
    
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
    
}

- (void)updateCollectionView {
    
    self.dresses = [NSMutableArray arrayWithArray:self.user.dresses.allObjects];
    
    if (!self.dresses.count) {
        
        self.informationLabel.hidden = NO;
        self.dressCollectionView.hidden = YES;
        
    }
    
    [self.dressCollectionView reloadData];
    
}

#pragma mark - UICollectionViewDataSource Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return (NSInteger)self.dresses.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DressCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DRESS_CUSTOM_CELL_ID forIndexPath:indexPath];
    cell.delegate = self;
    
    Dress *dress = (Dress *)self.dresses[(NSUInteger)indexPath.row];
    
    cell.dressImageView.image = [UIImage imageWithData:dress.dressData];
        
    UIImage *bookmarkOrUnbookmarkImage = (dress.isBookmarked.boolValue) ? [UIImage imageNamed:BOOKMARKED_IMAGE] : [UIImage imageNamed:UNBOOKMARKED_IMAGE];
    
    [cell.bookmarkButton setImage:bookmarkOrUnbookmarkImage forState:UIControlStateNormal];
    
    return cell;
    
}

#pragma mark - Dress delegate method

- (void)bookmarkSelectedDress {
    
    DressCollectionViewCell *cell = self.dressCollectionView.visibleCells.firstObject;
    
    NSIndexPath *indexPath = [self.dressCollectionView indexPathForCell:cell];
    NSLog(@"%@",indexPath);
    
    Dress *dress = (Dress *)self.dresses[(NSUInteger)indexPath.row];
    dress.isBookmarked = (dress.isBookmarked.boolValue) ? @(0) : @(1);
    
    NSError *error;
    
    if (![self.appDelegate.managedObjectContext save:&error]) {
        
        NSLog(@"Error : %@", error.localizedDescription);
        
        return;
        
    }
    
    [self.dressCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

- (void)nextDressImage:(id)sender {
    
    UIButton *dislikeButton = (UIButton *)sender;
    
    DressCollectionViewCell *cell = (DressCollectionViewCell *)dislikeButton.superview.superview;
    
    NSIndexPath *indexPath = [self.dressCollectionView indexPathForCell:cell];
    NSLog(@"%@",indexPath);
    
    NSInteger nextRow = indexPath.row;
    nextRow++;
    
    if (nextRow >= self.dresses.count) {
        
        indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
    }
    else {
     
        indexPath = [NSIndexPath indexPathForItem:nextRow inSection:0];
        
    }
    
    [self.view layoutIfNeeded];
    [self.dressCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}


#pragma mark - FBSDKSharer delegate method

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    
    NSLog(@"Share Complete");
    [Utility showAlertWithTitle:ALERT_TITLE_KEY message:DRESS_SHARED controller:self completionBlock:^(UIAlertAction *action) {
        
        NSLog(@"Ok tapped");
        
    }];
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
    NSLog(@"Share Failed");
    
    [Utility showAlertWithTitle:ALERT_TITLE_KEY message:error.localizedDescription controller:self completionBlock:^(UIAlertAction *action) {
        
        NSLog(@"Ok tapped");
        
    }];
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    
    NSLog(@"Share Cancel");
    
}

@end
