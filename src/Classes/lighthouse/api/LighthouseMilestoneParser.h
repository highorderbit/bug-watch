//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Milestone;

@interface LighthouseMilestoneParser : NSObject
{
    NSString * className;
    NSDictionary * attributeMappings;
    NSString * classElementType;
    NSString * classElementCollection;

    id obj;

    NSMutableString * elementPath;
    NSMutableString * elementValue;
    NSMutableString * elementType;
    NSMutableArray * elements;
}

@property (nonatomic, copy) NSString * className;
@property (nonatomic, copy) NSDictionary * attributeMappings;
@property (nonatomic, copy) NSString * classElementType;
@property (nonatomic, copy) NSString * classElementCollection;

- (id)parse:(NSData *)xml;

@end
