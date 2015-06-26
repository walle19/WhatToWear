//
//  BookMarkViewController.m
//  fbDemo
//
//  Created by Nikhil Wali on 21/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import <FBSDKShareKit/FBSDKShareKit.h>

#import "BookMarkViewController.h"
#import "Dress.h"

NSString * const BOOKMARKED_DRESS_CUSTOM_CELL_ID = @"bookmarkedCell";

@interface BookMarkViewController ()<FBSDKSharingDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *bookmarkedDressCollectionView;

@property (nonatomic, strong) NSMutableArray *bookmarkedDresses;

@property (nonatomic, weak) IBOutlet UILabel *informationLabel;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation BookMarkViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.bookmarkedDresses = nil;
    
    [self addShareBarButton];
    
    [self updateCollectionView];
    
    self.appDelegate = [Utility appDelegateInstance];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Business Logic

- (void)addShareBarButton {
    
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:SHARE_ICON] style:UIBarButtonItemStylePlain target:self action:@selector(shareDressImage)];
    
    self.navigationItem.rightBarButtonItems = @[shareBarButtonItem];
    
}

- (void)updateCollectionView {
    
    self.bookmarkedDresses = [NSMutableArray arrayWithArray:self.user.dresses.allObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmarked = 1"];
    
    NSArray *bookmarks = self.bookmarkedDresses.copy;
    bookmarks = [bookmarks filteredArrayUsingPredicate:predicate];
    
    self.bookmarkedDresses = [NSMutableArray arrayWithArray:bookmarks];
    
    
    if (![self isAnyDressAvailable]) {
        
        return;
        
    }
    
    [self.bookmarkedDressCollectionView reloadData];
    
}

- (BOOL)isAnyDressAvailable {
    
    if (!self.bookmarkedDresses.count) {
        
        self.informationLabel.hidden = NO;
        self.bookmarkedDressCollectionView.hidden = YES;
        
        return NO;
        
    }
    
    return YES;
    
}

- (void)shareDressImage {
    
    DressCollectionViewCell *cell = self.bookmarkedDressCollectionView.visibleCells.lastObject;
    
    NSIndexPath *indexPath = [self.bookmarkedDressCollectionView indexPathForCell:cell];
    NSLog(@"indexPath : %@",indexPath);
    
    Dress *dress = self.bookmarkedDresses[(NSUInteger)indexPath.row];
    
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = [UIImage imageWithData:dress.dressData];
    photo.userGenerated = YES;
    
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
    
}

#pragma mark - UICollectionViewDataSource Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return (NSInteger)self.bookmarkedDresses.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DressCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BOOKMARKED_DRESS_CUSTOM_CELL_ID forIndexPath:indexPath];
    cell.delegate = self;
    
    Dress *dress = (Dress *)self.bookmarkedDresses[(NSUInteger)indexPath.row];
    
    cell.dressImageView.image = [UIImage imageWithData:dress.dressData];
    
    if (dress.isBookmarked.boolValue) {
        
        cell.bookmarkButton.imageView.image = [UIImage imageNamed:@"bookmark-black"];
        
    }
    else {
        
        cell.bookmarkButton.imageView.image = [UIImage imageNamed:@"profile"];
    }
    
    return cell;
    
}

#pragma mark - Dress delegate method

- (void)bookmarkSelectedDress:(id)sender {
    
    UIButton *dislikeButton = (UIButton *)sender;
    
    DressCollectionViewCell *cell = (DressCollectionViewCell *)dislikeButton.superview.superview;
    
    NSIndexPath *indexPath = [self.bookmarkedDressCollectionView indexPathForCell:cell];
    
    Dress *dress = (Dress *)self.bookmarkedDresses[(NSUInteger)indexPath.row];
    dress.isBookmarked = @(0);
    
    NSError *error;
    
    if (![self.appDelegate.managedObjectContext save:&error]) {
        
        NSLog(@"Error : %@", error.localizedDescription);
        
        return;
        
    }
    
    [self.bookmarkedDresses removeObjectAtIndex:(NSUInteger)indexPath.row];
    
    if (![self isAnyDressAvailable]) {
        
        return;
        
    }
    
    [self.bookmarkedDressCollectionView reloadData];
    
}

#pragma mark - FBSDKSharer delegate method

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    
    NSLog(@"Share Complete");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [Utility showAlertWithTitle:ALERT_TITLE_KEY message:DRESS_SHARED controller:self completionBlock:^(UIAlertAction *action) {
        
        NSLog(@"Ok tapped");
        
    }];
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
    NSLog(@"Share Failed");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [Utility showAlertWithTitle:ALERT_TITLE_KEY message:error.localizedDescription controller:self completionBlock:^(UIAlertAction *action) {
        
        NSLog(@"Ok tapped");
        
    }];
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    
    NSLog(@"Share Cancel");
    
}


@end
