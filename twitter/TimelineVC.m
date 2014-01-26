//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"
#import <objc/runtime.h>
@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onSignOutButton;
- (void)onCompose;
- (void)reload;
-(void) putProfileImage: (NSDictionary *)params ;
-(void) requestProfileImageURL: (NSIndexPath *) indexPath;
-(NSString *)dateDiff:(NSString *)origDate;

@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIImage *logoImage = [UIImage imageNamed:@"Bird.png"];
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target: self action: @selector(onCompose)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"TweetCell"];
    UINib *customNibTweetView = [UINib nibWithNibName:@"TweetViewController" bundle:nil];
    [self.tableView registerNib:customNibTweetView forCellReuseIdentifier:@"TweetViewController"];
    UINib *customNibComposeView = [UINib nibWithNibName:@"ComposeViewController" bundle:nil];
    [self.tableView registerNib:customNibComposeView forCellReuseIdentifier:@"ComposeViewController"];
    
    
    //Adding pull to refresh controls
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    refreshControl.tintColor = [UIColor blueColor];
    [refreshControl addTarget:self action:@selector(reload)forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog (@"Called row method");
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    Tweet *tweet = self.tweets[indexPath.row];
    //cell.textLabel.text = tweet.text;
    
    //Setting the tweet label
    cell.tweetLabel.numberOfLines = 0;
    cell.tweetLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.tweetLabel.text = tweet.text;
   
    
    //Setting the profile image
    [self performSelectorInBackground:@selector(requestProfileImageURL:) withObject:indexPath];
    
    //Setting the user name
    cell.userName.text = tweet.userName;
    [cell.userName sizeToFit];
    
    //Setting the timestamp
    
    NSString* dateString = [self dateDiff:tweet.timeStamp];
   
    cell.timeStamp.text = dateString;
    
    //Setting the user screen name
   
    cell.userScreenName.text =   [NSString stringWithFormat:@"@%@",tweet.userTwitterName];
    
    
    
  
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog (@"Called height method");
    return 150;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewController *tvc = [[TweetViewController alloc]initWithNibName:@"TweetViewController" bundle:Nil];
    
    tvc.tweetObject = self.tweets[indexPath.row];
    [self.navigationController pushViewController:tvc animated:YES];
    
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
    
}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

-(void)onCompose {
    NSLog(@"Compose called");
    ComposeViewController *cvc = [[ComposeViewController alloc]initWithNibName:@"ComposeViewController"bundle:Nil];
    
    
    cvc.replyToID = nil;
    cvc.replyToUser = nil;
    [self.navigationController pushViewController:cvc animated:YES];
    
}

#pragma mark - Image URL methods
-(void) requestProfileImageURL: (NSIndexPath *) indexPath{
    
    //NSLog (@"In request profile method");
    
    Tweet *currTweet = [self.tweets objectAtIndex:indexPath.row];
    NSURL *imageURL =  [NSURL URLWithString:currTweet.imageUrl];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:indexPath,image,nil] forKeys:[NSArray arrayWithObjects:@"indexPath",@"image", nil]];
    
    [self performSelectorOnMainThread:@selector(putProfileImage:) withObject:params waitUntilDone:NO];
    
}

-(void) putProfileImage:(NSDictionary * )params {
    
   // NSLog (@"In put Profile method");
    
    NSIndexPath *indexPath = [params valueForKeyPath:@"indexPath"];
    UIImage *image = [params valueForKeyPath:@"image"];
   
    //NSLog (@"The row is :%u",indexPath.row);
    UITableViewCell *fromcell =  [self.tableView cellForRowAtIndexPath:indexPath];
    TweetCell *cell = (TweetCell *) fromcell;
    cell.userImage.layer.cornerRadius = 12;
    cell.userImage.layer.masksToBounds = YES;
    [cell.userImage setImage:image];
   
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:YES];
    //[self.tableView reloadData];
    
    
  
}
#pragma mark Date diff method ( referred from StackOverflow :http://stackoverflow.com/questions/902950/iphone-convert-date-string-to-a-relative-time-stamp)

-(NSString *)dateDiff:(NSString *)origDate {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz yyyy"];
    
    NSDate *tweetdate = [dateFormat dateFromString:origDate];
    
 
    NSDate *todayDate = [NSDate date];
    double ti = [tweetdate timeIntervalSinceDate:todayDate];
   
    ti = ti * -1;
    if(ti < 1) {
    	return @"--";
    } else 	if (ti < 60) {
    	return @"1min";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
    	return [NSString stringWithFormat:@"%dmin", diff];
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
    	return[NSString stringWithFormat:@"%dh", diff];
    } else if (ti < 2629743) {
    	int diff = round(ti / 60 / 60 / 24);
    	return[NSString stringWithFormat:@"%dd", diff];
    } else {
    	return @"+1 ago";
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
