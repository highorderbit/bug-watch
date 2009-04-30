//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "BugWatchAppController.h"

@implementation BugWatchAppController

- (void)dealloc
{
    [ticketsViewController release];
    [super dealloc];
}

@end
