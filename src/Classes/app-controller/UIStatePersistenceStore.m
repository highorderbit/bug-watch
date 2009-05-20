//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIStatePersistenceStore.h"
#import "PListUtils.h"

@interface UIStatePersistenceStore (Private)

+ (NSString *)plistName;
+ (NSString *)selectedTabKey;

@end

@implementation UIStatePersistenceStore

- (void)dealloc
{
    [super dealloc];
}

- (UIState *)load
{
    UIState * state = [[[UIState alloc] init] autorelease];

    NSDictionary * dict =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];

    NSUInteger selectedTab =
        [[dict objectForKey:[[self class] selectedTabKey]] unsignedIntValue];

    state.selectedTab = selectedTab;

    return state;
}

- (void)save:(UIState *)state
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    NSNumber * selectedTab = [NSNumber numberWithUnsignedInt:state.selectedTab];
    [dict setObject:selectedTab forKey:[[self class] selectedTabKey]];

    [PlistUtils saveDictionary:dict toPlist:[[self class] plistName]];
}

+ (NSString *)plistName
{
    return @"UIState";
}

+ (NSString *)selectedTabKey
{
    return @"selectedTab";
}

@end
