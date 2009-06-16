//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseCredentials.h"

@interface LighthouseCredentialsPersistenceStore : NSObject
{
}

+ (id)store;
- (id)init;

- (LighthouseCredentials *)loadWithPlist:(NSString *)plist;
- (void)saveCredentials:(LighthouseCredentials *)credentials
                toPlist:(NSString *)plist;

@end
