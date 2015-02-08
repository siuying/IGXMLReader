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
