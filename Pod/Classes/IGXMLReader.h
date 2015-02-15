//
//  IGXMLReader.h
//  IGXMLReader
//
//  Created by Chan Fai Chong on 8/2/15.
//  Copyright (c) 2015 Francis Chong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IGXMLReaderNodeType) {
    IGXMLReaderNodeTypeNone                     = 0,
    IGXMLReaderNodeTypeElement                  = 1,
    IGXMLReaderNodeTypeAttribute                = 2,
    IGXMLReaderNodeTypeText                     = 3,
    IGXMLReaderNodeTypeCDATA                    = 4,
    IGXMLReaderNodeTypeEntityReference          = 5,
    IGXMLReaderNodeTypeEntity                   = 6,
    IGXMLReaderNodeTypeProcessingInstruction    = 7,
    IGXMLReaderNodeTypeComment                  = 8,
    IGXMLReaderNodeTypeDocument                 = 9,
    IGXMLReaderNodeTypeDocumentType             = 10,
    IGXMLReaderNodeTypeDocumentFragment         = 11,
    IGXMLReaderNodeTypeNotation                 = 12,
    IGXMLReaderNodeTypeWhitespace               = 13,
    IGXMLReaderNodeTypeSignificantWhitespace    = 14,
    IGXMLReaderNodeTypeEndElement               = 15,
    IGXMLReaderNodeTypeEndEntity                = 16,
    IGXMLReaderNodeTypeXmlDeclaration           = 17
};


/**
 * The IGXMLReader parser allows you to effectively pull parse an XML document. 
 * Once instantiated, call #nextObject to iterate over each node. Note that you may only iterate over the document once!
 */
@interface IGXMLReader : NSEnumerator

-(instancetype) initWithXMLString:(NSString*)XMLString;

-(instancetype) initWithXMLString:(NSString*)XMLString URL:(NSURL*)URL;

-(instancetype) initWithXMLData:(NSData*)data URL:(NSURL*)URL encoding:(NSString*)encoding;

-(instancetype) initWithXMLData:(NSData*)data URL:(NSURL*)URL encoding:(NSString*)encoding options:(int)options;

-(instancetype) nextObject;

-(void) enumerateNodesUsingBlock:(void (^) (IGXMLReader* node))block;

@end

@interface IGXMLReader (Node)

/**
 * @return name of current node.
 */
-(NSString*) name;

/**
 * @param name name of attribute
 * @return value of attribute with specified name, of current element. or nil if not an element.
 */
-(NSString*) attributeWithName:(NSString*)name;

/**
 * @param index number of index
 * @return value of n-th attribute of current element, or nil if not an element.
 */
-(NSString*) attributeAtIndex:(NSUInteger)index;

/**
 * @return number of attributes of current element, or 0 if not an element.
 */
-(NSInteger) attributeCount;

/**
 * @return attributes of current element. If current node is not an element, returns an empty Dictionary.
 */
-(NSDictionary*) attributes;

-(IGXMLReaderNodeType) type;

-(NSString*) typeDescription;

-(NSString*) value;

-(NSInteger) depth;

/**
 * @return return YES if this is an empty (self-closing) element. return NO if this is not an element, or not an empty element.
 */
-(BOOL) isEmpty;

-(BOOL) hasValue;

-(BOOL) hasAttributes;

@end