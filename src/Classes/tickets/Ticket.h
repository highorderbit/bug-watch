//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TicketState {
    kNew,
    kOpen,
    kResolved,
    kHold,
    kInvalid
};

@interface Ticket : NSObject
{
    NSString * description;
    NSUInteger state;
    NSDate * creationDate;
    NSDate * lastModifiedDate;
    NSArray * comments;
}

@property (nonatomic, copy, readonly) NSString * description;
@property (nonatomic, readonly) NSUInteger state;
@property (nonatomic, copy, readonly) NSDate * creationDate;
@property (nonatomic, copy, readonly) NSDate * lastModifiedDate;
@property (nonatomic, copy, readonly) NSArray * comments;

- (id)initWithDescription:(NSString *)aDescription state:(NSUInteger)aState
    creationDate:(NSDate *)aCreationDate
    lastModifiedDate:(NSDate *)aLastModifiedDate
    comments:(NSArray *)someComments;

+ (NSString *)descriptionForState:(NSUInteger)ticketState;

@end
