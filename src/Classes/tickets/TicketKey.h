//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketKey : NSObject <NSCopying>
{
    id projectKey;
    NSUInteger ticketNumber;
}

@property (nonatomic, readonly) id projectKey;
@property (nonatomic, readonly) NSUInteger ticketNumber;

- (id)initWithProjectKey:(id)projectKey ticketNumber:(NSUInteger)ticketNumber;

- (NSComparisonResult)compare:(TicketKey *)anotherTicketKey;

@end
