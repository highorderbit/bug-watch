//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Milestone : NSObject <NSCopying>
{
    NSString * name;
    NSDate * dueDate;

    NSNumber * numOpenTickets;
    NSNumber * numTickets;
}

+ (id)milestoneWithName:(NSString *)aName dueDate:(NSDate *)aDueDate
    numOpenTickets:(NSNumber *)openTickets
    numTickets:(NSNumber *)totalNumTickets;

- (id)initWithName:(NSString *)aName dueDate:(NSDate *)aDueDate
    numOpenTickets:(NSNumber *)openTickets
    numTickets:(NSNumber *)totalNumTickets;

@property (nonatomic, readonly, copy) NSString * name;
@property (nonatomic, readonly, copy) NSDate * dueDate;
@property (nonatomic, readonly, copy) NSNumber * numOpenTickets;
@property (nonatomic, readonly, copy) NSNumber * numTickets;

// TODO: Replace me with real data

+ (NSArray *)dummyData;

@end
