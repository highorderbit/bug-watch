//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageDisplayProjectSetter.h"
#import "Project.h"

@implementation MessageDisplayProjectSetter

- (void)dealloc
{
    [messageDisplayMgr release];
    [super dealloc];
}

- (id)initWithMessageDisplayMgr:(MessageDisplayMgr *)aMessageDisplayMgr
{
    if (self = [super init])
        messageDisplayMgr = [aMessageDisplayMgr retain];

    return self;
}

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys
{
    NSLog(@"Setting projects on message display manager...");
    NSLog(@"Projects: %@", projects);
    NSMutableDictionary * projectDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < [keys count]; i++) {
        id key = [keys objectAtIndex:i];
        Project * project = [projects objectAtIndex:i];
        NSString * name = project.name;
        [projectDict setObject:name forKey:key];
    }

    messageDisplayMgr.projectDict = projectDict;
}

@end
