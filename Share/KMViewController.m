//
//  KMViewController.m
//  Share
//
//  Created by Kelli Mohr on 11/24/13.
//  Copyright (c) 2013 Kelli Mohr. All rights reserved.
//

#import "KMViewController.h"
#import <Social/Social.h>

@interface KMViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation KMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20.0f, 186.0f, 280.0f, 400.0f);
    [button setTitle:@"Get Image" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Photos"]) {
        NSLog(@"Photos Pressed");
    }
    if ([buttonTitle isEqualToString:@"Camera Roll"]) {
        NSLog(@"Camera Roll pressed");
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            
            [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
        else{
            NSLog(@"Photo Album not available");
        };
    }
    if ([buttonTitle isEqualToString:@"Camera"]) {
        NSLog(@"Camera pressed");
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else {
            [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        };
    }
    [picker setAllowsEditing:YES];
    
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"Showing Camera");
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        // show the image to the user
        [_imageView setImage:pickedImage];
        [self.view addSubview:_imageView];
        
        // save the image to the photos album
        UIImageWriteToSavedPhotosAlbum(pickedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    
}

- (void)showActionSheet:(id)sender
{
    NSString *actionSheetTitle = @"Get Image"; //Action Sheet Title
    NSString *camera = @"Camera";
    NSString *album = @"Camera Roll";
    NSString *destructiveTitle = @"Photos"; //Action Sheet Button Titles
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:album, camera, nil];
    [actionSheet showInView:self.view];
}

- (void)image: (UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (error) {
        NSLog(@"Unable to save photo to camera roll");
    } else {
        NSLog(@"Saved Image To Camera Roll");
    }
}

- (IBAction)shareAction:(UIBarButtonItem *)sender
{
    SLComposeViewController *shareViewController;
    
    switch (sender.tag) {
        case 0: // Twitter
            shareViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [shareViewController setInitialText:@"Sent to Twitter From Share App by Kelli Mohr"];
            [shareViewController addImage:_imageView.image];
            [shareViewController addURL:[NSURL URLWithString:@"http://twitter.com/shareapp"]];
            [self presentViewController:shareViewController animated:YES completion:nil];
            break;
        case 1: // Facebook
            shareViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [shareViewController setInitialText:@"Sent to Facebook from Share App by Kelli Mohr"];
            [shareViewController addImage:_imageView.image];
            [shareViewController addURL:[NSURL URLWithString:@"http://facebook.com/shareapp"]];
            [self presentViewController:shareViewController animated:YES completion:nil];
            break;
        case 2: // Activity
            
            break;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
