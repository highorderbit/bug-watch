//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIStatePersistenceStore.h"
#import "PListUtils.h"

@interface UIStatePersistenceStore (Private)

+ (NSString *)plistName;
+ (NSString *)selectedTabKey;
+ (NSString *)selectedProjectKey;
+ (NSString *)selectedProjectTabKey;

@end

@implementation UIStatePersistenceStore

- (UIState *)load
{
    UIState * state = [[[UIState alloc] init] autorelease];

    NSDictionary * dict =
        [PlistUtils getDictionaryFromPlist:[[self class] plistName]];

    NSUInteger selectedTab =
        [[dict objectForKey:[[self class] selectedTabKey]] unsignedIntValue];
    NSUInteger selectedProject =
        [[dict objectForKey:[[self class] selectedProjectKey]]
        unsignedIntValue];
    NSInteger selectedProjectTab =
        [[dict objectForKey:[[self class] selectedProjectTabKey]]
        unsignedIntValue];

    state.selectedTab = selectedTab;
    state.selectedProject = selectedProject;
    state.selectedProjectTab = selectedProjectTab;

    return state;
}

- (void)save:(UIState *)state
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    NSNumber * selectedTab = [NSNumber numberWithUnsignedInt:state.selectedTab];
    [dict setObject:selectedTab forKey:[[self class] selectedTabKey]];
    NSNumber * selectedProject =
        [NSNumber numberWithUnsignedInt:state.selectedProject];
    [dict setObject:selectedProject forKey:[[self class] selectedProjectKey]];
    NSNumber * selectedProjectTab =
        [NSNumber numberWithInt:state.selectedProjectTab];
    [dict setObject:selectedProjectTab
        forKey:[[self class] selectedProjectTabKey]];

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

+ (NSString *)selectedProjectKey
{
    return @"selectedProject";
}

+ (NSString *)selectedProjectTabKey
{
    return @"selectedProjectTab";
}

@end
