//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
{
    NSDate * postedDate;
    NSString * title;
    NSString * message;
}

@property (nonatomic, copy, readonly) NSDate * postedDate;
@property (nonatomic, copy, readonly) NSString * title;
@property (nonatomic, copy, readonly) NSString * message;

- (id)initWithPostedDate:(NSDate *)postedDate title:(NSString *)title
    message:(NSString *)message;

@end
