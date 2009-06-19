//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
{
    NSDate * postedDate;
    NSString * title;
    NSString * message;
    NSString * link;
    NSUInteger commentCount;
}

@property (nonatomic, copy, readonly) NSDate * postedDate;
@property (nonatomic, copy, readonly) NSString * title;
@property (nonatomic, copy, readonly) NSString * message;
@property (nonatomic, copy, readonly) NSString * link;
@property (nonatomic, assign, readonly) NSUInteger commentCount;

- (id)initWithPostedDate:(NSDate *)postedDate title:(NSString *)title
    message:(NSString *)message link:(NSString *)link
    commentCount:(NSUInteger)commentCount;

- (NSComparisonResult)compare:(Message *)anotherMessage;

@end
