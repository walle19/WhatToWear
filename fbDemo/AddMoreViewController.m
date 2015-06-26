//
//  AddMoreViewController.m
//  fbDemo
//
//  Created by Nikhil Wali on 22/06/15.
//  Copyright (c) 2015 Nikhil Wali. All rights reserved.
//

#import "AddMoreViewController.h"
#import "AppDelegate.h"

NSString * const IMAGE_SAVED_TEXT = @"Successfully added to closet";

NSString * const DRESS_DATA_KEY = @"dressData";
NSString * const IS_BOOKMARK_KEY = @"isBookmarked";
NSString * const USER_KEY = @"user";

NSString * const IMAGE_PLACEHOLDER_IMAGE_NAME = @"placeholder";

@interface AddMoreViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *previewImageView;

@property (nonatomic, weak) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation AddMoreViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /*!
     Default values
     */
    [self setDefaultValues];
    
    self.appDelegate = [Utility appDelegateInstance];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UIImagePickerControllerDelegate Method

/*
 This method is called when an image has been chosen from the library or taken from the camera.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSLog(@"%@ %@", image, path);
    
    __weak typeof(self) weakSelf = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        weakSelf.previewImageView.image = image;
        
        weakSelf.saveButton.enabled = YES;
        
    }];
    
}

#pragma mark - Business Logic

- (BOOL)saveImage:(UIImage *)dressImage error:(NSError *)error {
    
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    
    NSManagedObject *dress = [NSEntityDescription insertNewObjectForEntityForName:DRESS_ENTTY inManagedObjectContext:context];
    
    NSData *imageData = UIImagePNGRepresentation(self.previewImageView.image);
    
    [dress setValue: imageData forKey:DRESS_DATA_KEY];
    [dress setValue: 0 forKey:IS_BOOKMARK_KEY];
    [dress setValue: self.user forKey:USER_KEY];
    
    if (![context save:&error]) {
        
        return NO;
        
    }

    return YES;
    
}

- (void)setDefaultValues {
    
    self.saveButton.enabled = NO;
    self.previewImageView.image = [UIImage imageNamed:IMAGE_PLACEHOLDER_IMAGE_NAME];
    
}

#pragma mark - IBAction Method

- (IBAction)imageFRomGallery:(id)sender {
    
    NSLog(@"Gallery selected");
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)imageFromCamera:(id)sender {
    
    NSLog(@"Camera selected");
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)saveImage:(id)sender {
    
    NSError *error;
    
    if (![self saveImage:self.previewImageView.image error:error]) {
        
        NSLog(@"Error %@", error.localizedDescription);
        
        [Utility showAlertWithTitle:ALERT_TITLE_KEY message:error.localizedDescription controller:self completionBlock:^(UIAlertAction *action) {
            
            NSLog(@"Ok tapped");
            
        }];
        
        return;
        
    }
    
    // Successful added image to db
    [Utility showAlertWithTitle:ALERT_TITLE_KEY message:IMAGE_SAVED_TEXT controller:self completionBlock:^(UIAlertAction *action) {
        
        NSLog(@"Ok tapped");
        
        [self setDefaultValues];
    
    }];

    NSLog(@"Image saved");
    
}

@end
