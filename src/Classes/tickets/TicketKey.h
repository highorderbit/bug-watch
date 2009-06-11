//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketKey : NSObject <NSCopying>
{
    NSUInteger projectKey;
    NSUInteger ticketNumber;
}

@property (nonatomic, readonly) NSUInteger projectKey;
@property (nonatomic, readonly) NSUInteger ticketNumber;

- (id)initWithProjectKey:(NSUInteger)projectKey
    ticketNumber:(NSUInteger)ticketNumber;

- (NSComparisonResult)compare:(TicketKey *)anotherTicketKey;

@end
