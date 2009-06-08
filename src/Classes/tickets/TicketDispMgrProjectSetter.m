//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDispMgrProjectSetter.h"
#import "Project.h"

@implementation TicketDispMgrProjectSetter

- (void)dealloc
{
    [ticketDisplayMgr release];
    [super dealloc];
}

- (id)initWithTicketDisplayMgr:(TicketDisplayMgr *)aTicketDisplayMgr
{
    if (self = [super init])
        ticketDisplayMgr = [aTicketDisplayMgr retain];

    return self;
}

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys
{
    NSLog(@"Setting projects on ticket display manager...");
    NSLog(@"Projects: %@", projects);
    NSMutableDictionary * projectDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < [keys count]; i++) {
        id key = [keys objectAtIndex:i];
        Project * project = [projects objectAtIndex:i];
        NSString * name = project.name;
        [projectDict setObject:name forKey:key];
    }

    ticketDisplayMgr.projectDict = projectDict;
}

@end
