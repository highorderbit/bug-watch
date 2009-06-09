//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDisplayMgr.h"

@interface MessageDisplayUserSetter : NSObject
{
    MessageDisplayMgr * messageDisplayMgr;
}

- (id)initWithMessageDisplayMgr:(MessageDisplayMgr *)aMessageDisplayMgr;
- (void)fetchedAllUsers:(NSDictionary *)users;

@end
