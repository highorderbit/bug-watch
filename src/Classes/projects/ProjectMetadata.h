//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectMetadata : NSObject
{
    NSUInteger openTicketsCount;
}

- (id)initWithOpenTicketsCount:(NSUInteger)anOpenTicketsCount;

@property (readonly) NSUInteger openTicketsCount;

@end
