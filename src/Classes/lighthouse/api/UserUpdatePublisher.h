//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractUpdatePublisher.h"

@interface UserUpdatePublisher : AbstractUpdatePublisher
{
}

//
// The selector provided should have the same arguments as:
//   - (void)allUsers:(NSDictionary *)users fetchedForProject:(id)projectKey;
//
+ (id)publisherWithListener:(id)listener action:(SEL)action;
- (id)initWithListener:(id)listener action:(SEL)action;

@end
