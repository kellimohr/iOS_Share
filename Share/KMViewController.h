//
//  KMViewController.h
//  Share
//
//  Created by Kelli Mohr on 11/24/13.
//  Copyright (c) 2013 Kelli Mohr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMViewController : UIViewController  <UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *schemeLabel;

- (IBAction)openSession:(id)sender;

@end
