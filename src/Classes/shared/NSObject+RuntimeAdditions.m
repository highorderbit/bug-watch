//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSObject+RuntimeAdditions.h"

#if TARGET_OS_IPHONE
#import <objc/runtime.h>
#endif

@implementation NSObject (RuntimeAdditions)

#if TARGET_OS_IPHONE

+ (NSString *)className
{
    return [NSString stringWithUTF8String:class_getName(self->isa)];
}

- (NSString *)className
{
    return [[self class] className];
}

#endif

+ (Class)classNamed:(NSString *)name
{
    return objc_lookUpClass([name UTF8String]);
}

@end