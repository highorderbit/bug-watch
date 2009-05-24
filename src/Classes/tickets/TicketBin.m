//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "TicketBin.h"

@interface TicketBin ()

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * searchString;
@property (nonatomic, assign) NSInteger ticketCount;

@end

@implementation TicketBin

@synthesize name, searchString, ticketCount;

+ (id)ticketBinWithName:(NSString *)aName searchString:(NSString *)aSearchString
    ticketCount:(NSInteger)aTicketCount
{
    return
        [[[[self class] alloc] initWithName:aName searchString:aSearchString
        ticketCount:aTicketCount] autorelease];
}

- (void)dealloc
{
    [name release];
    [searchString release];
    [super dealloc];
}

- (id)initWithName:(NSString *)aName searchString:(NSString *)aSearchString
    ticketCount:(NSInteger)aTicketCount
{
    if (self = [super init]) {
        self.name = aName;
        self.searchString = aSearchString;
        self.ticketCount = aTicketCount;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (NSString *)description
{
    return
        [NSString stringWithFormat:@"ticket bin: '%@', search string: '%@', "
        "ticket count: %u", name, searchString, ticketCount];
}

@end
