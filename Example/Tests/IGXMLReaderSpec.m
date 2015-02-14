//
//  IGXMLReaderSpec.m
//  IGXMLReaderTests
//
//  Created by Francis Chong on 02/08/2015.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "IGXMLReader.h"

SPEC_BEGIN(IGXMLReaderSpec)

describe(@"IGXMLReader", ^{
    __block IGXMLReader* reader;

    context(@"#isEmpty", ^{
        it(@"should return empty element if it is", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<xml><city>Paris</city><state/></xml>"];
            
            NSMutableArray* isEmptyArray = [NSMutableArray array];
            IGXMLReader* node;
            while (node = [reader  nextObject]) {
                if ([node type] == IGXMLReaderNodeTypeElement) {
                    [isEmptyArray addObject:@([node isEmpty])];
                }
            }
            
            [[isEmptyArray should] equal:@[@NO, @NO, @YES]];
        });
    });

    context(@"#hasAttributes", ^{
        it(@"should return YES when has attributes", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:tenderlove='http://tenderlovemaking.com/'>\
                      <tenderlove:foo awesome='true'>snuggles!</tenderlove:foo>\
                      <c></c>\
                      </x>"];

            NSMutableArray* hasAttributesArray = [NSMutableArray array];
            IGXMLReader* node;
            while (node = [reader  nextObject]) {
                if ([node type] == IGXMLReaderNodeTypeElement) {
                    [hasAttributesArray addObject:@([node hasAttributes])];
                }
            }
            
            [[hasAttributesArray should] equal:@[@YES, @YES, @NO]];
        });
    });

    context(@"#attributes", ^{
        it(@"should return attributes maps", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:tenderlove='http://tenderlovemaking.com/'\
                      xmlns='http://mothership.connection.com/'\
                      >\
                      <tenderlove:foo awesome='true'>snuggles!</tenderlove:foo>\
                      </x>"];

            NSMutableArray* attributesArray = [NSMutableArray array];
            IGXMLReader* node;
            while (node = [reader  nextObject]) {
                if ([node type] == IGXMLReaderNodeTypeElement) {
                    [attributesArray addObject:[node attributes]];
                }
            }
            [[attributesArray should] equal:@[@{@"xmlns:tenderlove": @"http://tenderlovemaking.com/", @"xmlns": @"http://mothership.connection.com/"},
                                              @{@"awesome": @"true"}]];
        });
    });

    context(@"#nextObject", ^{
        describe(@"when at a start tag", ^{
            beforeEach(^{
                reader = [[IGXMLReader alloc] initWithXMLString:@"<document></document>"];
                [reader nextObject];
            });

            it(@"should return start element", ^{
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeElement)];
            });

            it(@"should return tag name", ^{
                [[[reader name] should] equal:@"document"];
            });

            it(@"should return current depth", ^{
                [[theValue([reader depth]) should] equal:theValue(0)];
            });
        });
        
        describe(@"when at a end tag", ^{
            beforeEach(^{
                reader = [[IGXMLReader alloc] initWithXMLString:@"<document><item></item></document>"];
                [reader nextObject];
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeElement)];

                [reader nextObject];
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeElement)];
                [reader nextObject];
            });

            it(@"should return end element", ^{
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeEndElement)];
            });

            it(@"should return tag name", ^{
                [[[reader name] should] equal:@"item"];
            });

            it(@"should return current depth", ^{
                [[theValue([reader depth]) should] equal:theValue(1)];
            });
        });
        
        describe(@"when at a text", ^{
            beforeEach(^{
                reader = [[IGXMLReader alloc] initWithXMLString:@"<content>text &quot;la&#x0A; la </content>"];
                [reader nextObject];
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeElement)];
                
                [reader nextObject];
            });
            
            it(@"should return text element", ^{
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeText)];
            });
            
            it(@"should return value", ^{
                [[[reader value] should] equal:@"text \"la\n la "];
            });
            
            it(@"should return current depth", ^{
                [[theValue([reader depth]) should] equal:theValue(1)];
            });
        });
        
        describe(@"when at a comment", ^{
            beforeEach(^{
                reader = [[IGXMLReader alloc] initWithXMLString:@"<!-- comment --><tag></tag>"];
                [reader nextObject];
            });
            
            it(@"should return comment", ^{
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeComment)];
            });
            
            it(@"should return comment text", ^{
                [[[reader value] should] equal:@" comment "];
            });
            
            it(@"should return current depth", ^{
                [[theValue([reader depth]) should] equal:theValue(0)];
            });
        });
    });
    
});

SPEC_END
