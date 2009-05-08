//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "Milestone.h"

@interface Milestone ()

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSDate * dueDate;
@property (nonatomic, copy) NSNumber * numOpenTickets;
@property (nonatomic, copy) NSNumber * numTickets;

@end

@implementation Milestone

@synthesize name, dueDate, numOpenTickets, numTickets;

- (void)dealloc
{
    [name release];
    [dueDate release];

    [numOpenTickets release];
    [numTickets release];

    [super dealloc];
}

#pragma mark Initialization

+ (id)milestoneWithName:(NSString *)aName dueDate:(NSDate *)aDueDate
    numOpenTickets:(NSNumber *)openTickets
    numTickets:(NSNumber *)totalNumTickets
{
    return [[[[self class] alloc] initWithName:aName dueDate:aDueDate
        numOpenTickets:openTickets numTickets:totalNumTickets] autorelease];
}

- (id)initWithName:(NSString *)aName dueDate:(NSDate *)aDueDate
    numOpenTickets:(NSNumber *)openTickets
    numTickets:(NSNumber *)totalNumTickets
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
        "open tickets: %@, number of tickets: %@:", name, dueDate,
        numOpenTickets, numTickets];
}

#pragma mark NSCopying protocol implementation

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];  // immutable
}

#pragma mark NSKeyValueCoding informal protocol implementation

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"Attempting to set value '%@' for undefined key: '%@'.", value, key);
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
            numOpenTickets:[NSNumber numberWithInteger:1]
            numTickets:[NSNumber numberWithInteger:40]],
        [[self class] milestoneWithName:@"The Big 1.0" dueDate:nextWeek
            numOpenTickets:[NSNumber numberWithInteger:4]
            numTickets:[NSNumber numberWithInteger:40]],
        [[self class] milestoneWithName:@"1.1.0" dueDate:nextMonth
            numOpenTickets:[NSNumber numberWithInteger:30]
            numTickets:[NSNumber numberWithInteger:40]],
        [[self class] milestoneWithName:@"1.2.0" dueDate:nil
            numOpenTickets:[NSNumber numberWithInteger:40]
            numTickets:[NSNumber numberWithInteger:40]],
        nil];
}

@end
