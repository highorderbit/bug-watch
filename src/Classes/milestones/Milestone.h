//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Milestone : NSObject <NSCopying>
{
    NSString * name;
    NSDate * dueDate;

    NSUInteger numOpenTickets;
    NSUInteger numTickets;

    NSString * goals;
}

+ (id)milestoneWithName:(NSString *)aName dueDate:(NSDate *)aDueDate
    numOpenTickets:(NSUInteger)openTickets
    numTickets:(NSUInteger)totalNumTickets goals:(NSString *)someGoals;

- (id)initWithName:(NSString *)aName dueDate:(NSDate *)aDueDate
    numOpenTickets:(NSUInteger)openTickets
    numTickets:(NSUInteger)totalNumTickets goals:(NSString *)someGoals;

@property (nonatomic, readonly, copy) NSString * name;
@property (nonatomic, readonly, copy) NSDate * dueDate;
@property (nonatomic, readonly, assign) NSUInteger numOpenTickets;
@property (nonatomic, readonly, assign) NSUInteger numTickets;
@property (nonatomic, readonly, copy) NSString * goals;

- (BOOL)completed;
- (BOOL)isLate;

// TODO: Replace me with real data

+ (NSArray *)dummyData;

@end
