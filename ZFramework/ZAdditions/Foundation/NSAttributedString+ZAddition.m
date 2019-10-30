//
//  NSAttributedString+ZAddition.m
//  ZFramework
//
//  Created by ronglei on 16/7/25.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "NSAttributedString+ZAddition.h"
#import "NSParagraphStyle+YYText.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (ZAddition)

- (NSDictionary *)attributesAtIndex:(NSUInteger)index {
    if (self.length > 0 && index == self.length) index--;
    return [self attributesAtIndex:index effectiveRange:NULL];
}

- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

- (NSDictionary *)attributes {
    return [self attributesAtIndex:0];
}

- (UIFont *)font {
    return [self fontAtIndex:0];
}

- (UIFont *)fontAtIndex:(NSUInteger)index {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    UIFont *font = [self attribute:NSFontAttributeName atIndex:index];
//    if (kSystemVersion <= 6) {
//        if (font) {
//            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) {
//                font = [UIFont fontWithCTFont:(CTFontRef)font];
//            }
//        }
//    }
    return font;
}

- (NSNumber *)kern {
    return [self kernAtIndex:0];
}

- (NSNumber *)kernAtIndex:(NSUInteger)index {
    return [self attribute:NSKernAttributeName atIndex:index];
}

- (UIColor *)color {
    return [self colorAtIndex:0];
}

- (UIColor *)colorAtIndex:(NSUInteger)index {
    UIColor *color = [self attribute:NSForegroundColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self attribute:(NSString *)kCTForegroundColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    if (color && ![color isKindOfClass:[UIColor class]]) {
        if (CFGetTypeID((__bridge CFTypeRef)(color)) == CGColorGetTypeID()) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        } else {
            color = nil;
        }
    }
    return color;
}

- (UIColor *)backgroundColor {
    return [self backgroundColorAtIndex:0];
}

- (UIColor *)backgroundColorAtIndex:(NSUInteger)index {
    return [self attribute:NSBackgroundColorAttributeName atIndex:index];
}

- (NSNumber *)strokeWidth {
    return [self strokeWidthAtIndex:0];
}

- (NSNumber *)strokeWidthAtIndex:(NSUInteger)index {
    return [self attribute:NSStrokeWidthAttributeName atIndex:index];
}

- (UIColor *)strokeColor {
    return [self strokeColorAtIndex:0];
}

- (UIColor *)strokeColorAtIndex:(NSUInteger)index {
    UIColor *color = [self attribute:NSStrokeColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self attribute:(NSString *)kCTStrokeColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSShadow *)shadow {
    return [self shadowAtIndex:0];
}

- (NSShadow *)shadowAtIndex:(NSUInteger)index {
    return [self attribute:NSShadowAttributeName atIndex:index];
}

- (NSUnderlineStyle)strikethroughStyle {
    return [self strikethroughStyleAtIndex:0];
}

- (NSUnderlineStyle)strikethroughStyleAtIndex:(NSUInteger)index {
    NSNumber *style = [self attribute:NSStrikethroughStyleAttributeName atIndex:index];
    return style.integerValue;
}

- (UIColor *)strikethroughColor {
    return [self strikethroughColorAtIndex:0];
}

- (UIColor *)strikethroughColorAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:NSStrikethroughColorAttributeName atIndex:index];
    }
    return nil;
}

- (NSUnderlineStyle)underlineStyle {
    return [self underlineStyleAtIndex:0];
}

- (NSUnderlineStyle)underlineStyleAtIndex:(NSUInteger)index {
    NSNumber *style = [self attribute:NSUnderlineStyleAttributeName atIndex:index];
    return style.integerValue;
}

- (UIColor *)underlineColor {
    return [self underlineColorAtIndex:0];
}

- (UIColor *)underlineColorAtIndex:(NSUInteger)index {
    UIColor *color = nil;
    if (kSystemVersion >= 7) {
        color = [self attribute:NSUnderlineColorAttributeName atIndex:index];
    }
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self attribute:(NSString *)kCTUnderlineColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSNumber *)ligature {
    return [self ligatureAtIndex:0];
}

- (NSNumber *)ligatureAtIndex:(NSUInteger)index {
    return [self attribute:NSLigatureAttributeName atIndex:index];
}

- (NSString *)textEffect {
    return [self textEffectAtIndex:0];
}

- (NSString *)textEffectAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:NSTextEffectAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)obliqueness {
    return [self obliquenessAtIndex:0];
}

- (NSNumber *)obliquenessAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:NSObliquenessAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)expansion {
    return [self expansionAtIndex:0];
}

- (NSNumber *)expansionAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:NSExpansionAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)baselineOffset {
    return [self baselineOffsetAtIndex:0];
}

- (NSNumber *)baselineOffsetAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:NSBaselineOffsetAttributeName atIndex:index];
    }
    return nil;
}

- (BOOL)verticalGlyphForm {
    return [self verticalGlyphFormAtIndex:0];
}

- (BOOL)verticalGlyphFormAtIndex:(NSUInteger)index {
    NSNumber *num = [self attribute:NSVerticalGlyphFormAttributeName atIndex:index];
    return num.boolValue;
}

- (NSString *)language {
    return [self languageAtIndex:0];
}

- (NSString *)languageAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self attribute:(id)kCTLanguageAttributeName atIndex:index];
    }
    return nil;
}

- (NSArray *)writingDirection {
    return [self writingDirectionAtIndex:0];
}

- (NSArray *)writingDirectionAtIndex:(NSUInteger)index {
    return [self attribute:(id)kCTWritingDirectionAttributeName atIndex:index];
}

- (NSParagraphStyle *)paragraphStyle {
    return [self paragraphStyleAtIndex:0];
}

- (NSParagraphStyle *)paragraphStyleAtIndex:(NSUInteger)index {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    NSParagraphStyle *style = [self attribute:NSParagraphStyleAttributeName atIndex:index];
    if (style) {
        if (CFGetTypeID((__bridge CFTypeRef)(style)) == CTParagraphStyleGetTypeID()) { \
            style = [NSParagraphStyle styleWithCTStyle:(__bridge CTParagraphStyleRef)(style)];
        }
    }
    return style;
}

#define ParagraphAttribute(_attr_) \
NSParagraphStyle *style = self.paragraphStyle; \
if (!style) style = [NSParagraphStyle defaultParagraphStyle]; \
return style. _attr_;

#define ParagraphAttributeAtIndex(_attr_) \
NSParagraphStyle *style = [self paragraphStyleAtIndex:index]; \
if (!style) style = [NSParagraphStyle defaultParagraphStyle]; \
return style. _attr_;

- (NSTextAlignment)alignment {
    ParagraphAttribute(alignment);
}

- (NSLineBreakMode)lineBreakMode {
    ParagraphAttribute(lineBreakMode);
}

- (CGFloat)lineSpacing {
    ParagraphAttribute(lineSpacing);
}

- (CGFloat)paragraphSpacing {
    ParagraphAttribute(paragraphSpacing);
}

- (CGFloat)paragraphSpacingBefore {
    ParagraphAttribute(paragraphSpacingBefore);
}

- (CGFloat)firstLineHeadIndent {
    ParagraphAttribute(firstLineHeadIndent);
}

- (CGFloat)headIndent {
    ParagraphAttribute(headIndent);
}

- (CGFloat)tailIndent {
    ParagraphAttribute(tailIndent);
}

- (CGFloat)minimumLineHeight {
    ParagraphAttribute(minimumLineHeight);
}

- (CGFloat)maximumLineHeight {
    ParagraphAttribute(maximumLineHeight);
}

- (CGFloat)lineHeightMultiple {
    ParagraphAttribute(lineHeightMultiple);
}

- (NSWritingDirection)baseWritingDirection {
    ParagraphAttribute(baseWritingDirection);
}

- (float)hyphenationFactor {
    ParagraphAttribute(hyphenationFactor);
}

- (CGFloat)defaultTabInterval {
    if (!kiOS7Later) return 0;
    ParagraphAttribute(defaultTabInterval);
}

- (NSArray *)tabStops {
    if (!kiOS7Later) return nil;
    ParagraphAttribute(tabStops);
}

- (NSTextAlignment)alignmentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(alignment);
}

- (NSLineBreakMode)lineBreakModeAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineBreakMode);
}

- (CGFloat)lineSpacingAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineSpacing);
}

- (CGFloat)paragraphSpacingAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(paragraphSpacing);
}

- (CGFloat)paragraphSpacingBeforeAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(paragraphSpacingBefore);
}

- (CGFloat)firstLineHeadIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(firstLineHeadIndent);
}

- (CGFloat)headIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(headIndent);
}

- (CGFloat)tailIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(tailIndent);
}

- (CGFloat)minimumLineHeightAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(minimumLineHeight);
}

- (CGFloat)maximumLineHeightAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(maximumLineHeight);
}

- (CGFloat)lineHeightMultipleAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineHeightMultiple);
}

- (NSWritingDirection)baseWritingDirectionAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(baseWritingDirection);
}

- (float)hyphenationFactorAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(hyphenationFactor);
}

- (CGFloat)defaultTabIntervalAtIndex:(NSUInteger)index {
    if (!kiOS7Later) return 0;
    ParagraphAttributeAtIndex(defaultTabInterval);
}

- (NSArray *)tabStopsAtIndex:(NSUInteger)index {
    if (!kiOS7Later) return nil;
    ParagraphAttributeAtIndex(tabStops);
}

#undef ParagraphAttribute
#undef ParagraphAttributeAtIndex


@end

@implementation NSMutableAttributedString (ZAddition)

- (void)setAttributes:(NSDictionary *)attributes {
    if (attributes == (id)[NSNull null]) attributes = nil;
    [self setAttributes:@{} range:NSMakeRange(0, self.length)];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setAttribute:key value:obj];
    }];
}

- (void)setAttribute:(NSString *)name value:(id)value {
    [self setAttribute:name value:value range:NSMakeRange(0, self.length)];
}

- (void)setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

- (void)removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

#pragma mark - Property Setter

- (void)setFont:(UIFont *)font {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self setFont:font range:NSMakeRange(0, self.length)];
}

- (void)setKern:(NSNumber *)kern {
    [self setKern:kern range:NSMakeRange(0, self.length)];
}

- (void)setColor:(UIColor *)color {
    [self setColor:color range:NSMakeRange(0, self.length)];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self setBackgroundColor:backgroundColor range:NSMakeRange(0, self.length)];
}

- (void)setStrokeWidth:(NSNumber *)strokeWidth {
    [self setStrokeWidth:strokeWidth range:NSMakeRange(0, self.length)];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    [self setStrokeColor:strokeColor range:NSMakeRange(0, self.length)];
}

- (void)setShadow:(NSShadow *)shadow {
    [self setShadow:shadow range:NSMakeRange(0, self.length)];
}

- (void)setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle {
    [self setStrikethroughStyle:strikethroughStyle range:NSMakeRange(0, self.length)];
}

- (void)setStrikethroughColor:(UIColor *)strikethroughColor {
    [self setStrokeColor:strikethroughColor range:NSMakeRange(0, self.length)];
}

- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle {
    [self setUnderlineStyle:underlineStyle range:NSMakeRange(0, self.length)];
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    [self setUnderlineColor:underlineColor range:NSMakeRange(0, self.length)];
}

- (void)setLigature:(NSNumber *)ligature {
    [self setLigature:ligature range:NSMakeRange(0, self.length)];
}

- (void)setTextEffect:(NSString *)textEffect {
    [self setTextEffect:textEffect range:NSMakeRange(0, self.length)];
}

- (void)setObliqueness:(NSNumber *)obliqueness {
    [self setObliqueness:obliqueness range:NSMakeRange(0, self.length)];
}

- (void)setExpansion:(NSNumber *)expansion {
    [self setExpansion:expansion range:NSMakeRange(0, self.length)];
}

- (void)setBaselineOffset:(NSNumber *)baselineOffset {
    [self setBaselineOffset:baselineOffset range:NSMakeRange(0, self.length)];
}

- (void)setVerticalGlyphForm:(BOOL)verticalGlyphForm {
    [self setVerticalGlyphForm:verticalGlyphForm range:NSMakeRange(0, self.length)];
}

- (void)setLanguage:(NSString *)language {
    [self setLanguage:language range:NSMakeRange(0, self.length)];
}

- (void)setWritingDirection:(NSArray *)writingDirection {
    [self setWritingDirection:writingDirection range:NSMakeRange(0, self.length)];
}

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    [self setParagraphStyle:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)setAlignment:(NSTextAlignment)alignment {
    [self setAlignment:alignment range:NSMakeRange(0, self.length)];
}

- (void)setBaseWritingDirection:(NSWritingDirection)baseWritingDirection {
    [self setBaseWritingDirection:baseWritingDirection range:NSMakeRange(0, self.length)];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    [self setLineSpacing:lineSpacing range:NSMakeRange(0, self.length)];
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing {
    [self setParagraphSpacing:paragraphSpacing range:NSMakeRange(0, self.length)];
}

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [self setParagraphSpacing:paragraphSpacingBefore range:NSMakeRange(0, self.length)];
}

- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self setFirstLineHeadIndent:firstLineHeadIndent range:NSMakeRange(0, self.length)];
}

- (void)setHeadIndent:(CGFloat)headIndent {
    [self setHeadIndent:headIndent range:NSMakeRange(0, self.length)];
}

- (void)setTailIndent:(CGFloat)tailIndent {
    [self setTailIndent:tailIndent range:NSMakeRange(0, self.length)];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self setLineBreakMode:lineBreakMode range:NSMakeRange(0, self.length)];
}

- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight {
    [self setMinimumLineHeight:minimumLineHeight range:NSMakeRange(0, self.length)];
}

- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight {
    [self setMaximumLineHeight:maximumLineHeight range:NSMakeRange(0, self.length)];
}

- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple {
    [self setLineHeightMultiple:lineHeightMultiple range:NSMakeRange(0, self.length)];
}

- (void)setHyphenationFactor:(float)hyphenationFactor {
    [self setHyphenationFactor:hyphenationFactor range:NSMakeRange(0, self.length)];
}

- (void)setDefaultTabInterval:(CGFloat)defaultTabInterval {
    [self setDefaultTabInterval:defaultTabInterval range:NSMakeRange(0, self.length)];
}
#pragma mark - Range Setter

- (void)setFont:(UIFont *)font range:(NSRange)range {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self setAttribute:NSFontAttributeName value:font range:range];
}

- (void)setKern:(NSNumber *)kern range:(NSRange)range {
    [self setAttribute:NSKernAttributeName value:kern range:range];
}

- (void)setColor:(UIColor *)color range:(NSRange)range {
    [self setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    [self setAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range {
    [self setAttribute:NSBackgroundColorAttributeName value:backgroundColor range:range];
}

- (void)setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range {
    [self setAttribute:NSStrokeWidthAttributeName value:strokeWidth range:range];
}

- (void)setStrokeColor:(UIColor *)strokeColor range:(NSRange)range {
    [self setAttribute:(id)kCTStrokeColorAttributeName value:(id)strokeColor.CGColor range:range];
    [self setAttribute:NSStrokeColorAttributeName value:strokeColor range:range];
}

- (void)setShadow:(NSShadow *)shadow range:(NSRange)range {
    [self setAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle range:(NSRange)range {
    NSNumber *style = strikethroughStyle == 0 ? nil : @(strikethroughStyle);
    [self setAttribute:NSStrikethroughStyleAttributeName value:style range:range];
}

- (void)setStrikethroughColor:(UIColor *)strikethroughColor range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSStrikethroughColorAttributeName value:strikethroughColor range:range];
    }
}

- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range {
    NSNumber *style = underlineStyle == 0 ? nil : @(underlineStyle);
    [self setAttribute:NSUnderlineStyleAttributeName value:style range:range];
}

- (void)setUnderlineColor:(UIColor *)underlineColor range:(NSRange)range {
    [self setAttribute:(id)kCTUnderlineColorAttributeName value:(id)underlineColor.CGColor range:range];
    if (kSystemVersion >= 7) {
        [self setAttribute:NSUnderlineColorAttributeName value:underlineColor range:range];
    }
}

- (void)setLigature:(NSNumber *)ligature range:(NSRange)range {
    [self setAttribute:NSLigatureAttributeName value:ligature range:range];
}

- (void)setTextEffect:(NSString *)textEffect range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSTextEffectAttributeName value:textEffect range:range];
    }
}

- (void)setObliqueness:(NSNumber *)obliqueness range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSObliquenessAttributeName value:obliqueness range:range];
    }
}

- (void)setExpansion:(NSNumber *)expansion range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSExpansionAttributeName value:expansion range:range];
    }
}

- (void)setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:NSBaselineOffsetAttributeName value:baselineOffset range:range];
    }
}

- (void)setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range {
    NSNumber *v = verticalGlyphForm ? @(YES) : nil;
    [self setAttribute:NSVerticalGlyphFormAttributeName value:v range:range];
}

- (void)setLanguage:(NSString *)language range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self setAttribute:(id)kCTLanguageAttributeName value:language range:range];
    }
}

- (void)setWritingDirection:(NSArray *)writingDirection range:(NSRange)range {
    [self setAttribute:(id)kCTWritingDirectionAttributeName value:writingDirection range:range];
}

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    [self setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

#define ParagraphStyleSet(_attr_) \
[self enumerateAttribute:NSParagraphStyleAttributeName \
inRange:range \
options:kNilOptions \
usingBlock: ^(NSParagraphStyle *value, NSRange subRange, BOOL *stop) { \
NSMutableParagraphStyle *style = nil; \
if (value) { \
if (CFGetTypeID((__bridge CFTypeRef)(value)) == CTParagraphStyleGetTypeID()) { \
value = [NSParagraphStyle styleWithCTStyle:(__bridge CTParagraphStyleRef)(value)]; \
} \
if (value. _attr_ == _attr_) return; \
if ([value isKindOfClass:[NSMutableParagraphStyle class]]) { \
style = (id)value; \
} else { \
style = value.mutableCopy; \
} \
} else { \
if ([NSParagraphStyle defaultParagraphStyle]. _attr_ == _attr_) return; \
style = [NSParagraphStyle defaultParagraphStyle].mutableCopy; \
} \
style. _attr_ = _attr_; \
[self setParagraphStyle:style range:subRange]; \
}];

- (void)setAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    ParagraphStyleSet(alignment);
}

- (void)setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range {
    ParagraphStyleSet(baseWritingDirection);
}

- (void)setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    ParagraphStyleSet(lineSpacing);
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range {
    ParagraphStyleSet(paragraphSpacing);
}

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range {
    ParagraphStyleSet(paragraphSpacingBefore);
}

- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range {
    ParagraphStyleSet(firstLineHeadIndent);
}

- (void)setHeadIndent:(CGFloat)headIndent range:(NSRange)range {
    ParagraphStyleSet(headIndent);
}

- (void)setTailIndent:(CGFloat)tailIndent range:(NSRange)range {
    ParagraphStyleSet(tailIndent);
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range {
    ParagraphStyleSet(lineBreakMode);
}

- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range {
    ParagraphStyleSet(minimumLineHeight);
}

- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range {
    ParagraphStyleSet(maximumLineHeight);
}

- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range {
    ParagraphStyleSet(lineHeightMultiple);
}

- (void)setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range {
    ParagraphStyleSet(hyphenationFactor);
}

- (void)setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range {
    if (!kiOS7Later) return;
    ParagraphStyleSet(defaultTabInterval);
}



@end
