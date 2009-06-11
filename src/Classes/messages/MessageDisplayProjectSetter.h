//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDisplayMgr.h"

@interface MessageDisplayProjectSetter : NSObject
{
    MessageDisplayMgr * messageDisplayMgr;
}

- (id)initWithMessageDisplayMgr:(MessageDisplayMgr *)aMessageDisplayMgr;
- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys;

@end
