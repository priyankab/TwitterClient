//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *imageUrl;
@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *timeStamp;
@property (nonatomic, strong, readonly) NSString *idNo;
@property (nonatomic, strong, readonly) NSString *userTwitterName;
@property (nonatomic, strong, readonly) NSString *favCount;
@property (nonatomic, strong, readonly) NSString *retweetCount;
+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
