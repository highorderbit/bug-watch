//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketMetaData.h"  // imported here for TicketState

@interface TicketDataWrapper : NSObject
{
    NSNumber * ticketNumber;

    // tickets
    NSString * description;
    NSDate * creationDate;
    NSString * link;

    // ticket metadata
    NSString * tags;
    TicketState state;
    NSDate * lastModifiedDate;

    NSNumber * milestoneId;
    NSNumber * projectId;
    NSNumber * userId;
    NSNumber * creatorId;
}

@property (nonatomic, copy) NSNumber * ticketNumber;

@property (nonatomic, copy) NSString * description;
@property (nonatomic, copy) NSDate * creationDate;
@property (nonatomic, copy) NSString * link;

@property (nonatomic, copy) NSString * tags;
@property (nonatomic, assign) TicketState state;
@property (nonatomic, copy) NSDate * lastModifiedDate;

@property (nonatomic, copy) NSNumber * milestoneId;
@property (nonatomic, copy) NSNumber * projectId;
@property (nonatomic, copy) NSNumber * userId;
@property (nonatomic, copy) NSNumber * creatorId;

@end


@interface TicketDataCollector : NSObject
{
    NSMutableArray * ticketNumbers;
    NSMutableArray * tickets;
    NSMutableArray * metadata;
    NSMutableArray * milestoneIds;
    NSMutableArray * projectIds;
    NSMutableArray * userIds;
    NSMutableArray * creatorIds;
}

@property (nonatomic, retain, readonly) NSMutableArray * ticketNumbers;
@property (nonatomic, retain, readonly) NSMutableArray * tickets;
@property (nonatomic, retain, readonly) NSMutableArray * metadata;
@property (nonatomic, retain, readonly) NSMutableArray * milestoneIds;
@property (nonatomic, retain, readonly) NSMutableArray * projectIds;
@property (nonatomic, retain, readonly) NSMutableArray * userIds;
@property (nonatomic, retain, readonly) NSMutableArray * creatorIds;

- (id)initWithDataWrappers:(NSArray *)wrappers;

@end
