//
//  TweetModel.h
//  twitter
//
//  Created by Priyanka Bhalerao on 1/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetModel : NSObject
@property (strong,nonatomic) NSString *tweetText;
@property (strong,nonatomic) NSString *profileUrl;
@property (strong,nonatomic) NSString *timestamp;

@end
