//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractUpdatePublisher.h"

@interface CredentialsUpdatePublisher : AbstractUpdatePublisher
{
}

//
// The selector provided should have the same arguments as:
//   - (void)credentialsChanged:(LighthouseCredentials *)credentials;
//
+ (id)publisherWithListener:(id)listener action:(SEL)action;
- (id)initWithListener:(id)listener action:(SEL)action;

@end
