//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseKey.h"

@interface LighthouseKey (Serialization)

+ (NSString *)stringFromLighthouseKey:(LighthouseKey *)ticketKey;
+ (LighthouseKey *)lighthouseKeyFromString:(NSString *)string;

@end
