//
//  ComposeViewController.h
//  twitter
//
//  Created by Priyanka Bhalerao on 1/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *composeText;
@property (weak, nonatomic) NSString *replyToID;
@property (weak, nonatomic) NSString *replyToUser;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end
