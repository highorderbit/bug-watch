//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketDiffHelpers.h"

@interface TicketComment : NSObject
{
    NSString * stateChangeDescription;
    TicketDiff * stateChange;
    NSString * text;
    NSDate * date;
}

@property (nonatomic, copy, readonly) NSString * stateChangeDescription;
@property (nonatomic, copy, readonly) TicketDiff * stateChange;
@property (nonatomic, copy, readonly) NSString * text;
@property (nonatomic, copy, readonly) NSDate * date;

- (id) initWithStateChangeDescription:(NSString *)aStateChangeDescription
    stateChange:(TicketDiff *)stateChange text:(NSString *)someText
    date:(NSDate *)aDate;

- (NSComparisonResult)compare:(TicketComment *)anotherTicketComment;

@end
