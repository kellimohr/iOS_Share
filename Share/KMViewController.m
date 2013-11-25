//
//  KMViewController.m
//  Share
//
//  Created by Kelli Mohr on 11/24/13.
//  Copyright (c) 2013 Kelli Mohr. All rights reserved.
//

#import "KMViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface KMViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

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
        case 2: // Email and Messages
            //shareViewController =
            break;
    }
    
}

#pragma mark - Actions

// -------------------------------------------------------------------------------
//	showMailPicker:
//  IBAction for the Compose Mail button.
// -------------------------------------------------------------------------------
- (IBAction)showMailPicker:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        [self displayMailComposerSheet];
    }
    else
        // The device can not send email.
    {
		NSLog(@"Device not configured to send mail.");
    }
}

// -------------------------------------------------------------------------------
//	showSMSPicker:
//  IBAction for the Compose SMS button.
// -------------------------------------------------------------------------------
- (IBAction)showSMSPicker:(id)sender
{
    if ([MFMessageComposeViewController canSendText])
        // The device can send email.
    {
        [self displaySMSComposerSheet];
    }
    else
        // The device can not send email.
    {
		NSLog(@"Device not configured to send SMS.");
    }
}


#pragma mark - Compose Mail/SMS

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Check out my image from Share!"];
    
    NSData *data = UIImagePNGRepresentation(_imageView.image);
    [picker addAttachmentData:data mimeType:@"image/png" fileName:@"share-image"];
    [self presentViewController:picker animated:YES completion:nil];
	
	// Fill out the email body text
	NSString *emailBody = @"Hey!  Check out my image I sent from Share!";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker animated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an SMS composition interface inside the application.
// -------------------------------------------------------------------------------
- (void)displaySMSComposerSheet
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
    
    // You can specify the initial message text that will appear in the message
    // composer view controller.
    picker.body = @"Check out my image from Share.";
    [picker addAttachmentData:UIImagePNGRepresentation(_imageView.image) typeIdentifier:(@"kUTTypePNG") filename:@"share-image.png"];
    
	[self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{

	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: Mail sending canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: Mail saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: Mail sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: Mail sending failed");
			break;
		default:
			NSLog(@"Result: Mail not sent");
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//	messageComposeViewController:didFinishWithResult:
//  Dismisses the message composition interface when users tap Cancel or Send.
//  Proceeds to update the feedback message field with the result of the
//  operation.
// -------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
			NSLog(@"Result: SMS sending canceled");
			break;
		case MessageComposeResultSent:
			NSLog(@"Result: SMS sent");
			break;
		case MessageComposeResultFailed:
			NSLog(@"Result: SMS sending failed");
			break;
		default:
			NSLog(@"Result: SMS not sent");
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)getURL:(id)sender {
    NSLog(@"Button Pressed");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"share://test_page/one?token=12345&domain=foo.com"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
