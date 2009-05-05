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
}

+ (id)milestoneWithName:(NSString *)aName dueDate:(NSDate *)aDueDate
    numOpenTickets:(NSUInteger)openTickets
    numTickets:(NSUInteger)totalNumTickets;

- (id)initWithName:(NSString *)aName dueDate:(NSDate *)aDueDate
    numOpenTickets:(NSUInteger)openTickets
    numTickets:(NSUInteger)totalNumTickets;

@property (nonatomic, readonly, copy) NSString * name;
@property (nonatomic, readonly, copy) NSDate * dueDate;
@property (nonatomic, readonly, assign) NSUInteger numOpenTickets;
@property (nonatomic, readonly, assign) NSUInteger numTickets;

// TODO: Replace me with real data

+ (NSArray *)dummyData;

@end
