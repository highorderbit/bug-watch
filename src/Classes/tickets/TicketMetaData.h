//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kNew        = 1,
    kOpen       = kNew << 1,
    kResolved   = kOpen << 1,
    kHold       = kResolved << 1,
    kInvalid    = kHold << 1
} TicketState;

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

- (NSComparisonResult)compare:(TicketMetaData *)anotherTicketMetaData;

+ (NSString *)descriptionForState:(NSUInteger)ticketState;

@end
