//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageResponse : NSObject
{
    NSString * text;
    NSDate * date;
}

@property (nonatomic, copy, readonly) NSString * text;
@property (nonatomic, copy, readonly) NSDate * date;

- (id)initWithText:(NSString *)someText date:(NSDate *)aDate;

@end
