//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

@synthesize number;
@synthesize description;
@synthesize state;
@synthesize creationDate;
@synthesize lastModifiedDate;
@synthesize comments;

- (void)dealloc
{
    [description release];
    [creationDate release];
    [lastModifiedDate release];
    [comments release];

    [super dealloc];
}

- (id)initWithNumber:(NSUInteger)aNumber description:(NSString *)aDescription
    state:(NSUInteger)aState creationDate:(NSDate *)aCreationDate
    lastModifiedDate:(NSDate *)aLastModifiedDate
    comments:(NSArray *)someComments
{
    if (self = [super init]) {
        number = aNumber;
        description = [aDescription retain];
        state = aState;
        creationDate = [aCreationDate retain];
        lastModifiedDate = [aLastModifiedDate retain];
        comments = [someComments retain];
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
