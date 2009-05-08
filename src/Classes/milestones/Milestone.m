//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "Milestone.h"

@interface Milestone ()

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSDate * dueDate;
@property (nonatomic, assign) NSUInteger numOpenTickets;
@property (nonatomic, assign) NSUInteger numTickets;

@end

@implementation Milestone

@synthesize name, dueDate, numOpenTickets, numTickets;

- (void)dealloc
{
    [name release];
    [dueDate release];

    [super dealloc];
}

#pragma mark Initialization

+ (id)milestoneWithName:(NSString *)aName dueDate:(NSDate *)aDueDate
    numOpenTickets:(NSUInteger)openTickets
    numTickets:(NSUInteger)totalNumTickets
{
    return [[[[self class] alloc] initWithName:aName dueDate:aDueDate
        numOpenTickets:openTickets numTickets:totalNumTickets] autorelease];
}

- (id)initWithName:(NSString *)aName dueDate:(NSDate *)aDueDate
    numOpenTickets:(NSUInteger)openTickets
    numTickets:(NSUInteger)totalNumTickets
{
    if (self = [super init]) {
        self.name = aName;
        self.dueDate = aDueDate;
        self.numOpenTickets = openTickets;
        self.numTickets = totalNumTickets;
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"milestone: '%@', due: '%@', number of "
        "open tickets: %u, number of tickets: %u:", name, dueDate,
        numOpenTickets, numTickets];
}

#pragma mark NSCopying protocol implementation

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];  // immutable
}

// TODO: Replace me with real data

+ (NSArray *)dummyData
{
    NSDate * lastWeek = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 7];
    NSDate * nextWeek = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 7];
    NSDate * nextMonth =
        [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 30];

    return [NSArray arrayWithObjects:
        [[self class] milestoneWithName:@"1.0 Beta" dueDate:lastWeek
            numOpenTickets:1 numTickets:40],
        [[self class] milestoneWithName:@"The Big 1.0" dueDate:nextWeek
            numOpenTickets:4 numTickets:40],
        [[self class] milestoneWithName:@"1.1.0" dueDate:nextMonth
            numOpenTickets:30 numTickets:40],
        [[self class] milestoneWithName:@"1.2.0" dueDate:nil
            numOpenTickets:40 numTickets:40],
        nil];
}

@end
