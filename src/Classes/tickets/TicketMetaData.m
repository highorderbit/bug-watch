//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketMetaData.h"

@implementation TicketMetaData

@synthesize tags;
@synthesize state;
@synthesize lastModifiedDate;

- (void)dealloc
{
    [tags release];
    [lastModifiedDate release];
    [super dealloc];
}

- (id)initWithTags:(NSString *)someTags state:(NSUInteger)aState
    lastModifiedDate:(NSDate *)aLastModifiedDate
{
    if (self = [super init]) {
        tags = [someTags retain];
        state = aState;
        lastModifiedDate = [aLastModifiedDate retain];
    }
    
    return self;
}
    
- (id)copy
{
    return [self retain]; // safe because immutable
}

+ (NSString *)descriptionForState:(NSUInteger)ticketState
{
    NSString * stateDescription;
    switch(ticketState) {
        case kNew:
            stateDescription = @"new";
            break;
        case kOpen:
            stateDescription = @"open";
            break;
        case kResolved:
            stateDescription = @"resolved";
            break;
        case kHold:
            stateDescription = @"hold";
            break;
        case kInvalid:
            stateDescription = @"invalid";
            break;
    }
    
    return stateDescription;
}

@end
