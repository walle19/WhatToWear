//
//  DressCollectionViewCell.m
//  fbDemo
//
//  Created by Nikhil Wali on 25/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import "DressCollectionViewCell.h"

@implementation DressCollectionViewCell

- (IBAction)bookmarkedDress:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(bookmarkSelectedDress:)]) {
        
        [self.delegate bookmarkSelectedDress:sender];
        
    }
    
}

- (IBAction)dislikedDress:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(nextDressImage:)]) {
        
        [self.delegate nextDressImage:sender];
        
    }
    
}

@end
