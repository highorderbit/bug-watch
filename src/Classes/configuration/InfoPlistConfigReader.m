//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "InfoPlistConfigReader.h"
#import "PListUtils.h"

@implementation InfoPlistConfigReader

+ (id)reader
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
    return (self = [super init]);
}

- (id) valueForKey:(NSString *)key
{    
    NSString * fullPath = [PlistUtils fullBundlePathForPlist:@"Info"];
    NSDictionary * infoPList = [PlistUtils readDictionaryFromPlist:fullPath];
    
    return [infoPList objectForKey:key];
}

@end
