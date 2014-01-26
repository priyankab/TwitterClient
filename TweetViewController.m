//
//  TweetViewController.m
//  twitter
//
//  Created by Priyanka Bhalerao on 1/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"

@interface TweetViewController ()

@end

@implementation TweetViewController


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
    self.title  = @"Tweet";
    [self.retweetButton setImage:[UIImage imageNamed:@"Retweet.png"] forState:UIControlStateNormal];
    [self.retweetButton setTitle:@"" forState:UIControlStateNormal];

    [self.favoriteButton setImage:[UIImage imageNamed:@"Fav.png"] forState:UIControlStateNormal];
    [self.favoriteButton setTitle:@"" forState:UIControlStateNormal];
    
    [self.replyButton setImage: [UIImage imageNamed:@"Reply.png"] forState:UIControlStateNormal];
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    
    //Tweet
    self.tweetViewtext.text = self.tweetObject.text;
    self.tweetViewtext.numberOfLines = 0;
    self.tweetViewtext.lineBreakMode = NSLineBreakByWordWrapping;
    
    //Time of tweet
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz yyyy"];
    
    NSDate *date = [dateFormat dateFromString:self.tweetObject.timeStamp];
    
    NSDateFormatter *displayFormat = [[NSDateFormatter alloc] init];
    [displayFormat setDateFormat:@"MM/dd/yyy HH:mm"];
    NSString *dateString = [displayFormat stringFromDate:date];
    
    self.tweetTime.text = dateString;
    
    //Username
    self.userLabel.text= self.tweetObject.userName;
    
    //Profile Pic
    
    NSURL *imageURL =  [NSURL URLWithString:self.tweetObject.imageUrl];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    [self.userImage setImage:image];
    
    //Screen name
    self.userScreenName.text = [NSString stringWithFormat:@"@%@",self.tweetObject.userTwitterName];
    
    
    //Favorites ans Reweet count
    NSLog (@" Tweet count :%@ and fav count : %@",self.tweetObject.retweetCount, self.tweetObject.favCount);
 
    self.retweetLabel.text = [NSString stringWithFormat:@"%@",self.tweetObject.retweetCount];
    self.favLabel.text =  [NSString  stringWithFormat:@"%@",self.tweetObject.favCount ];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRetweet:(id)sender {
    
    //NSLog (@"On Retweet called");
    
    NSString* tweetId = self.tweetObject.idNo;
    [[TwitterClient instance] retweetWithStringId:tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"%@",response);
        
        //self.tweets = [Tweet tweetsWithArray:response];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed !");
        NSLog(@"%@",[error localizedDescription]);
        // Do nothing
    }];
    

}
- (IBAction)onFavorite:(id)sender {
    NSLog (@"On Retweet called");
    
    NSString* tweetId = self.tweetObject.idNo;
    [[TwitterClient instance] favoriteWithStringId:tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@",response);
        
        //self.tweets = [Tweet tweetsWithArray:response];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed !");
        NSLog(@"%@",[error localizedDescription]);
        // Do nothing
    }];
}

- (IBAction)onReply:(id)sender {
    ComposeViewController *cvc = [[ComposeViewController alloc]initWithNibName:@"ComposeViewController"bundle:Nil];
    
    
    cvc.replyToID = self.tweetObject.idNo;
    cvc.replyToUser = self.tweetObject.userTwitterName;
    [self.navigationController pushViewController:cvc animated:YES];
}
@end
