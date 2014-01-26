//
//  TweetModel.m
//  twitter
//
//  Created by Priyanka Bhalerao on 1/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetModel.h"

@implementation TweetModel
- (id) initWithDictionary: (NSDictionary *) dictionary{
    self = [super init];
    if(self){
        self.tweetText = @"Hi new text";
    }
    return self;
}

@end
