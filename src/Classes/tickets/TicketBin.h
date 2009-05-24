//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger UNKNOWN_TICKET_BIN_COUNT = -1;

@interface TicketBin : NSObject <NSCopying>
{
    NSString * name;
    NSString * searchString;

    NSInteger ticketCount;
}

@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, copy, readonly) NSString * searchString;
@property (nonatomic, assign, readonly) NSInteger ticketCount;

+ (id)ticketBinWithName:(NSString *)aName searchString:(NSString *)aSearchString
    ticketCount:(NSInteger)aTicketCount;

- (id)initWithName:(NSString *)aName searchString:(NSString *)aSearchString
    ticketCount:(NSInteger)aTicketCount;

@end