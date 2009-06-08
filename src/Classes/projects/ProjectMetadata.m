//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectMetadata.h"

@implementation ProjectMetadata

@synthesize openTicketsCount;

- (id)initWithOpenTicketsCount:(NSUInteger)anOpenTicketsCount
{
    if (self = [super init])
        openTicketsCount = anOpenTicketsCount;

    return self;
}

- (id)copy
{
    return [self retain];
}

@end
