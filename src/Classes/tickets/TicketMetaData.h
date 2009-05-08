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

@interface TicketMetaData : NSObject
{
    NSString * tags;
    NSUInteger state;
    NSDate * lastModifiedDate;
}

@property (nonatomic, copy, readonly) NSString * tags;
@property (nonatomic, readonly) NSUInteger state;
@property (nonatomic, copy, readonly) NSDate * lastModifiedDate;

- (id)initWithTags:(NSString *)someTags state:(NSUInteger)aState
    lastModifiedDate:(NSDate *)aLastModifiedDate;

+ (NSString *)descriptionForState:(NSUInteger)ticketState;

@end