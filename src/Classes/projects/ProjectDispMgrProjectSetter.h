//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectDisplayMgr.h"

@interface ProjectDispMgrProjectSetter : NSObject
{
    ProjectDisplayMgr * projectDisplayMgr;
}

- (id)initWithProjectDisplayMgr:(ProjectDisplayMgr *)aProjectDisplayMgr;
- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys;

@end
