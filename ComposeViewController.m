//
//  ComposeViewController.m
//  twitter
//
//  Created by Priyanka Bhalerao on 1/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ComposeViewController.h"
BOOL clearField;

@interface ComposeViewController ()
- (void)onTweetButton;
- (void)onCancelButton;
- (IBAction)onTapAction:(id)sender;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
      
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    id userObject = [User currentUser];
    //NSLog(@"Now User is %@", userObject);
    //NSLog(@"username is %@", [userObject objectForKey:@"name"]);
    self.userNameLabel.text = [userObject objectForKey:@"name"];
    
    //Displaying Profile pic
    //Profile Pic
    NSString *profileURL = [userObject objectForKey:@"profile_image_url_https"];
    
    NSURL *imageURL =  [NSURL URLWithString:profileURL];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    [self.profileImage setImage:image];
    
    
    //User Screen name
    NSString *sname =[userObject objectForKey:@"screen_name"];
    self.screenName.text = [NSString stringWithFormat:@"@%@",sname];
    
    //Text View initializations
    clearField = NO;
    self.composeText.delegate = self;
    if(self.replyToUser != nil){
        
        [self.composeText setText: [NSString stringWithFormat:@"@%@",self.replyToUser ]];
    }
    [self.composeText becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Tweet methods
-(void) onTweetButton{
    NSLog(@"On tweet button called");
    NSString* status = self.composeText.text;
    [[TwitterClient instance] tweetWithUserText:status idString:self.replyToID success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@",response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed !");
        NSLog(@"%@",[error localizedDescription]);
        // Do nothing
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) onCancelButton{
    [self.composeText resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)onTapAction:(id)sender {
    [self.composeText resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark TextDelegate methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [textView setTextColor: [UIColor blackColor]];
    clearField = YES;
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    clearField = NO;
}

    
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(clearField == YES && self.replyToUser == nil){
        [textView setText:@"" ];
        clearField = NO;
    }
    return YES;
}



@end
