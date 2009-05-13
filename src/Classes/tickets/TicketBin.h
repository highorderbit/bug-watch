//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketBin : NSObject <NSCopying>
{
    NSString * name;
    NSString * searchString;

    NSUInteger ticketCount;
}

@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, copy, readonly) NSString * searchString;
@property (nonatomic, assign, readonly) NSUInteger ticketCount;

+ (id)ticketBinWithName:(NSString *)aName searchString:(NSString *)aSearchString
    ticketCount:(NSUInteger)aTicketCount;

- (id)initWithName:(NSString *)aName searchString:(NSString *)aSearchString
    ticketCount:(NSUInteger)aTicketCount;

@end