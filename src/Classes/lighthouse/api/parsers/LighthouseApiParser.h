//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LighthouseApiParser : NSObject
{
    NSString * className;
    NSDictionary * attributeMappings;
    NSString * classElementType;
    NSString * classElementCollection;

    id obj;

    NSString * elementPath;
    NSMutableString * elementValue;
    NSMutableString * elementType;
    NSMutableArray * elements;
    BOOL buildingObject;  // a bit hackey until support is added for paths
}

@property (nonatomic, copy) NSString * className;
@property (nonatomic, copy) NSDictionary * attributeMappings;
@property (nonatomic, copy) NSString * classElementType;
@property (nonatomic, copy) NSString * classElementCollection;

+ (id)parser;
- (id)init;

- (id)parse:(NSData *)xml;

@end
