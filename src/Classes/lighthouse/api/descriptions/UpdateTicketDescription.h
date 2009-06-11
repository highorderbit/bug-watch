//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketMetaData.h"

@interface UpdateTicketDescription : NSObject
{
    NSString * title;
    NSString * comment;

    TicketState state;
    BOOL ticketStateSet;

    id assignedUserKey;
    id milestoneKey;

    NSString * tags;
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * comment;
@property (nonatomic) TicketState state;
@property (nonatomic, copy) id assignedUserKey;
@property (nonatomic, copy) id milestoneKey;
@property (nonatomic, copy) NSString * tags;  // space or comma delimited list

+ (id)description;
- (id)init;

#pragma mark Convert to XML

- (NSString *)xmlDescriptionForProject:(id)projectKey;

@end
