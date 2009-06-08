//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractUpdatePublisher.h"

@interface AllUserUpdatePublisher : AbstractUpdatePublisher

//
// The selector provided should have the same arguments as:
//   - (void)fetchedAllUsers:(NSDictionary *)users;
//
+ (id)publisherWithListener:(id)listener action:(SEL)action;

@end
