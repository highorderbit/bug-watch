//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseCredentialsPersistenceStore.h"

@implementation LighthouseCredentialsPersistenceStore

+ (id)store
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
    return self = [super init];
}

- (LighthouseCredentials *)loadWithPlist:(NSString *)plist
{
    return [LighthouseCredentials loadFromPlist:plist];
}

- (void)saveCredentials:(LighthouseCredentials *)credentials
                toPlist:(NSString *)plist
{
    if (credentials)
        [credentials saveToPlist:plist];
    else {
        // do something else here, like maybe delete the plist file if it
        // exists
    }
}

@end
