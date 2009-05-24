//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractUpdatePublisher.h"

@interface ProjectUpdatePublisher : AbstractUpdatePublisher
{
}

//
// The selector provided should have the same arguments as:
//   - (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys;
//
+ (id)publisherWithListener:(id)listener action:(SEL)action;
- (id)initWithListener:(id)listener action:(SEL)action;

@end
