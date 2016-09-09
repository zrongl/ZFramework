//
//  NSAttributedString+ZAddition.h
//  ZFramework
//
//  Created by ronglei on 16/7/25.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ZAddition)

/**
 Returns the attributes at first charactor.
 */
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSString *, id> *attributes;

/**
 Returns the attributes for the character at a given index.
 
 @discussion Raises an `NSRangeException` if index lies beyond the end of the
 receiver's characters.
 
 @param index  The index for which to return attributes.
 This value must lie within the bounds of the receiver.
 
 @return The attributes for the character at index.
 */
- (nullable NSDictionary<NSString *, id> *)attributesAtIndex:(NSUInteger)index;

/**
 Returns the value for an attribute with a given name of the character at a given index.
 
 @discussion Raises an `NSRangeException` if index lies beyond the end of the
 receiver's characters.
 
 @param attributeName  The name of an attribute.
 @param index          The index for which to return attributes.
 This value must not exceed the bounds of the receiver.
 
 @return The value for the attribute named `attributeName` of the character at
 index `index`, or nil if there is no such attribute.
 */
- (nullable id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index;


#pragma mark - Get character attribute as property
///=============================================================================
/// @name Get character attribute as property
///=============================================================================

/**
 The font of the text. (read-only)
 
 @discussion Default is Helvetica (Neue) 12.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) UIFont *font;
- (nullable UIFont *)fontAtIndex:(NSUInteger)index;

/**
 A kerning adjustment. (read-only)
 
 @discussion Default is standard kerning. The kerning attribute indicate how many
 points the following character should be shifted from its default offset as
 defined by the current character's font in points; a positive kern indicates a
 shift farther along and a negative kern indicates a shift closer to the current
 character. If this attribute is not present, standard kerning will be used.
 If this attribute is set to 0.0, no kerning will be done at all.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) NSNumber *kern;
- (nullable NSNumber *)kernAtIndex:(NSUInteger)index;

/**
 The foreground color. (read-only)
 
 @discussion Default is Black.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) UIColor *color;
- (nullable UIColor *)colorAtIndex:(NSUInteger)index;

/**
 The background color. (read-only)
 
 @discussion Default is nil (or no background).
 @discussion Get this property returns the first character's attribute.
 @since UIKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) UIColor *backgroundColor;
- (nullable UIColor *)backgroundColorAtIndex:(NSUInteger)index;

/**
 The stroke width. (read-only)
 
 @discussion Default value is 0.0 (no stroke). This attribute, interpreted as
 a percentage of font point size, controls the text drawing mode: positive
 values effect drawing with stroke only; negative values are for stroke and fill.
 A typical value for outlined text is 3.0.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) NSNumber *strokeWidth;
- (nullable NSNumber *)strokeWidthAtIndex:(NSUInteger)index;

/**
 The stroke color. (read-only)
 
 @discussion Default value is nil (same as foreground color).
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) UIColor *strokeColor;
- (nullable UIColor *)strokeColorAtIndex:(NSUInteger)index;

/**
 The text shadow. (read-only)
 
 @discussion Default value is nil (no shadow).
 @discussion Get this property returns the first character's attribute.
 @since UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) NSShadow *shadow;
- (nullable NSShadow *)shadowAtIndex:(NSUInteger)index;

/**
 The strikethrough style. (read-only)
 
 @discussion Default value is NSUnderlineStyleNone (no strikethrough).
 @discussion Get this property returns the first character's attribute.
 @since UIKit:6.0
 */
@property (nonatomic, readonly) NSUnderlineStyle strikethroughStyle;
- (NSUnderlineStyle)strikethroughStyleAtIndex:(NSUInteger)index;

/**
 The strikethrough color. (read-only)
 
 @discussion Default value is nil (same as foreground color).
 @discussion Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nullable, nonatomic, strong, readonly) UIColor *strikethroughColor;
- (nullable UIColor *)strikethroughColorAtIndex:(NSUInteger)index;

/**
 The underline style. (read-only)
 
 @discussion Default value is NSUnderlineStyleNone (no underline).
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0
 */
@property (nonatomic, readonly) NSUnderlineStyle underlineStyle;
- (NSUnderlineStyle)underlineStyleAtIndex:(NSUInteger)index;

/**
 The underline color. (read-only)
 
 @discussion Default value is nil (same as foreground color).
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:7.0
 */
@property (nullable, nonatomic, strong, readonly) UIColor *underlineColor;
- (nullable UIColor *)underlineColorAtIndex:(NSUInteger)index;

/**
 Ligature formation control. (read-only)
 
 @discussion Default is int value 1. The ligature attribute determines what kinds
 of ligatures should be used when displaying the string. A value of 0 indicates
 that only ligatures essential for proper rendering of text should be used,
 1 indicates that standard ligatures should be used, and 2 indicates that all
 available ligatures should be used. Which ligatures are standard depends on the
 script and possibly the font.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) NSNumber *ligature;
- (nullable NSNumber *)ligatureAtIndex:(NSUInteger)index;

/**
 The text effect. (read-only)
 
 @discussion Default is nil (no effect). The only currently supported value
 is NSTextEffectLetterpressStyle.
 @discussion Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nullable, nonatomic, strong, readonly) NSString *textEffect;
- (nullable NSString *)textEffectAtIndex:(NSUInteger)index;

/**
 The skew to be applied to glyphs. (read-only)
 
 @discussion Default is 0 (no skew).
 @discussion Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nullable, nonatomic, strong, readonly) NSNumber *obliqueness;
- (nullable NSNumber *)obliquenessAtIndex:(NSUInteger)index;

/**
 The log of the expansion factor to be applied to glyphs. (read-only)
 
 @discussion Default is 0 (no expansion).
 @discussion Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nullable, nonatomic, strong, readonly) NSNumber *expansion;
- (nullable NSNumber *)expansionAtIndex:(NSUInteger)index;

/**
 The character's offset from the baseline, in points. (read-only)
 
 @discussion Default is 0.
 @discussion Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nullable, nonatomic, strong, readonly) NSNumber *baselineOffset;
- (nullable NSNumber *)baselineOffsetAtIndex:(NSUInteger)index;

/**
 Glyph orientation control. (read-only)
 
 @discussion Default is NO. A value of NO indicates that horizontal glyph forms
 are to be used, YES indicates that vertical glyph forms are to be used.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:4.3  YYKit:6.0
 */
@property (nonatomic, readonly) BOOL verticalGlyphForm;
- (BOOL)verticalGlyphFormAtIndex:(NSUInteger)index;

/**
 Specifies text language. (read-only)
 
 @discussion Value must be a NSString containing a locale identifier. Default is
 unset. When this attribute is set to a valid identifier, it will be used to select
 localized glyphs (if supported by the font) and locale-specific line breaking rules.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:7.0  YYKit:7.0
 */
@property (nullable, nonatomic, strong, readonly) NSString *language;
- (nullable NSString *)languageAtIndex:(NSUInteger)index;

/**
 Specifies a bidirectional override or embedding. (read-only)
 
 @discussion See alse NSWritingDirection and NSWritingDirectionAttributeName.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:7.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) NSArray<NSNumber *> *writingDirection;
- (nullable NSArray<NSNumber *> *)writingDirectionAtIndex:(NSUInteger)index;

/**
 The space after the end of the paragraph (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion This property contains the space (measured in points) added at the
 end of the paragraph to separate it from the following paragraph. This value must
 be nonnegative. The space between paragraphs is determined by adding the previous
 paragraph's paragraphSpacing and the current paragraph's paragraphSpacingBefore.
 @discussion Default is 0.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) CGFloat paragraphSpacing;
- (CGFloat)paragraphSpacingAtIndex:(NSUInteger)index;

#pragma mark - Get paragraph attribute as property
///=============================================================================
/// @name Get paragraph attribute as property
///=============================================================================

/**
 The text alignment (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion Natural text alignment is realized as left or right alignment
 depending on the line sweep direction of the first script contained in the paragraph.
 @discussion Default is NSTextAlignmentNatural.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) NSTextAlignment alignment;
- (NSTextAlignment)alignmentAtIndex:(NSUInteger)index;

/**
 The mode that should be used to break lines (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion This property contains the line break mode to be used laying out the paragraph's text.
 @discussion Default is NSLineBreakByWordWrapping.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) NSLineBreakMode lineBreakMode;
- (NSLineBreakMode)lineBreakModeAtIndex:(NSUInteger)index;

/**
 The distance in points between the bottom of one line fragment and the top of the next.
 (A wrapper for NSParagraphStyle) (read-only)
 
 @discussion This value is always nonnegative. This value is included in the line
 fragment heights in the layout manager.
 @discussion Default is 0.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) CGFloat lineSpacing;
- (CGFloat)lineSpacingAtIndex:(NSUInteger)index;

/**
 The distance between the paragraph's top and the beginning of its text content.
 (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion This property contains the space (measured in points) between the
 paragraph's top and the beginning of its text content.
 @discussion Default is 0.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) CGFloat paragraphSpacingBefore;
- (CGFloat)paragraphSpacingBeforeAtIndex:(NSUInteger)index;

/**
 The indentation of the first line (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion This property contains the distance (in points) from the leading margin
 of a text container to the beginning of the paragraph's first line. This value
 is always nonnegative.
 @discussion Default is 0.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) CGFloat firstLineHeadIndent;
- (CGFloat)firstLineHeadIndentAtIndex:(NSUInteger)index;

/**
 The indentation of the receiver's lines other than the first. (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion This property contains the distance (in points) from the leading margin
 of a text container to the beginning of lines other than the first. This value is
 always nonnegative.
 @discussion Default is 0.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) CGFloat headIndent;
- (CGFloat)headIndentAtIndex:(NSUInteger)index;

/**
 The trailing indentation (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion If positive, this value is the distance from the leading margin
 (for example, the left margin in left-to-right text). If 0 or negative, it's the
 distance from the trailing margin.
 @discussion Default is 0.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) CGFloat tailIndent;
- (CGFloat)tailIndentAtIndex:(NSUInteger)index;

/**
 The receiver's minimum height (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion This property contains the minimum height in points that any line in
 the receiver will occupy, regardless of the font size or size of any attached graphic.
 This value must be nonnegative.
 @discussion Default is 0.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) CGFloat minimumLineHeight;
- (CGFloat)minimumLineHeightAtIndex:(NSUInteger)index;

/**
 The receiver's maximum line height (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion This property contains the maximum height in points that any line in
 the receiver will occupy, regardless of the font size or size of any attached graphic.
 This value is always nonnegative. Glyphs and graphics exceeding this height will
 overlap neighboring lines; however, a maximum height of 0 implies no line height limit.
 Although this limit applies to the line itself, line spacing adds extra space between adjacent lines.
 @discussion Default is 0 (no limit).
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) CGFloat maximumLineHeight;
- (CGFloat)maximumLineHeightAtIndex:(NSUInteger)index;

/**
 The line height multiple (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion This property contains the line break mode to be used laying out the paragraph's text.
 @discussion Default is 0 (no multiple).
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) CGFloat lineHeightMultiple;
- (CGFloat)lineHeightMultipleAtIndex:(NSUInteger)index;

/**
 The base writing direction (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion If you specify NSWritingDirectionNaturalDirection, the receiver resolves
 the writing direction to either NSWritingDirectionLeftToRight or NSWritingDirectionRightToLeft,
 depending on the direction for the user's `language` preference setting.
 @discussion Default is NSWritingDirectionNatural.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readonly) NSWritingDirection baseWritingDirection;
- (NSWritingDirection)baseWritingDirectionAtIndex:(NSUInteger)index;

/**
 The paragraph's threshold for hyphenation. (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion Valid values lie between 0.0 and 1.0 inclusive. Hyphenation is attempted
 when the ratio of the text width (as broken without hyphenation) to the width of the
 line fragment is less than the hyphenation factor. When the paragraph's hyphenation
 factor is 0.0, the layout manager's hyphenation factor is used instead. When both
 are 0.0, hyphenation is disabled.
 @discussion Default is 0.
 @discussion Get this property returns the first character's attribute.
 @since UIKit:6.0
 */
@property (nonatomic, readonly) float hyphenationFactor;
- (float)hyphenationFactorAtIndex:(NSUInteger)index;

/**
 The document-wide default tab interval (A wrapper for NSParagraphStyle). (read-only)
 
 @discussion This property represents the default tab interval in points. Tabs after the
 last specified in tabStops are placed at integer multiples of this distance (if positive).
 @discussion Default is 0.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:7.0  UIKit:7.0  YYKit:7.0
 */
@property (nonatomic, readonly) CGFloat defaultTabInterval;
- (CGFloat)defaultTabIntervalAtIndex:(NSUInteger)index;

@end


@interface NSMutableAttributedString (ZAddition)

#pragma mark - Set character attribute
///=============================================================================
/// @name Set character attribute
///=============================================================================

/**
 Sets the attributes to the entire text string.
 
 @discussion The old attributes will be removed.
 
 @param attributes  A dictionary containing the attributes to set, or nil to remove all attributes.
 */
- (void)setAttributes:(nullable NSDictionary<NSString *, id> *)attributes;

/**
 Sets an attribute with the given name and value to the entire text string.
 
 @param name   A string specifying the attribute name.
 @param value  The attribute value associated with name. Pass `nil` or `NSNull` to
 remove the attribute.
 */
- (void)setAttribute:(NSString *)name value:(nullable id)value;

/**
 Sets an attribute with the given name and value to the characters in the specified range.
 
 @param name   A string specifying the attribute name.
 @param value  The attribute value associated with name. Pass `nil` or `NSNull` to
 remove the attribute.
 @param range  The range of characters to which the specified attribute/value pair applies.
 */
- (void)setAttribute:(NSString *)name value:(nullable id)value range:(NSRange)range;

/**
 Removes all attributes in the specified range.
 
 @param range  The range of characters.
 */
- (void)removeAttributesInRange:(NSRange)range;


#pragma mark - Set character attribute as property
///=============================================================================
/// @name Set character attribute as property
///=============================================================================

/**
 The font of the text.
 
 @discussion Default is Helvetica (Neue) 12.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readwrite) UIFont *font;
- (void)setFont:(nullable UIFont *)font range:(NSRange)range;

/**
 A kerning adjustment.
 
 @discussion Default is standard kerning. The kerning attribute indicate how many
 points the following character should be shifted from its default offset as
 defined by the current character's font in points; a positive kern indicates a
 shift farther along and a negative kern indicates a shift closer to the current
 character. If this attribute is not present, standard kerning will be used.
 If this attribute is set to 0.0, no kerning will be done at all.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readwrite) NSNumber *kern;
- (void)setKern:(nullable NSNumber *)kern range:(NSRange)range;

/**
 The foreground color.
 
 @discussion Default is Black.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readwrite) UIColor *color;
- (void)setColor:(nullable UIColor *)color range:(NSRange)range;

/**
 The background color.
 
 @discussion Default is nil (or no background).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:6.0
 */
@property (nullable, nonatomic, strong, readwrite) UIColor *backgroundColor;
- (void)setBackgroundColor:(nullable UIColor *)backgroundColor range:(NSRange)range;

/**
 The stroke width.
 
 @discussion Default value is 0.0 (no stroke). This attribute, interpreted as
 a percentage of font point size, controls the text drawing mode: positive
 values effect drawing with stroke only; negative values are for stroke and fill.
 A typical value for outlined text is 3.0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readwrite) NSNumber *strokeWidth;
- (void)setStrokeWidth:(nullable NSNumber *)strokeWidth range:(NSRange)range;

/**
 The stroke color.
 
 @discussion Default value is nil (same as foreground color).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readwrite) UIColor *strokeColor;
- (void)setStrokeColor:(nullable UIColor *)strokeColor range:(NSRange)range;

/**
 The text shadow.
 
 @discussion Default value is nil (no shadow).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readwrite) NSShadow *shadow;
- (void)setShadow:(nullable NSShadow *)shadow range:(NSRange)range;

/**
 The strikethrough style.
 
 @discussion Default value is NSUnderlineStyleNone (no strikethrough).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:6.0
 */
@property (nonatomic, readwrite) NSUnderlineStyle strikethroughStyle;
- (void)setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle range:(NSRange)range;

/**
 The strikethrough color.
 
 @discussion Default value is nil (same as foreground color).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nullable, nonatomic, strong, readwrite) UIColor *strikethroughColor;
- (void)setStrikethroughColor:(nullable UIColor *)strikethroughColor range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 The underline style.
 
 @discussion Default value is NSUnderlineStyleNone (no underline).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0
 */
@property (nonatomic, readwrite) NSUnderlineStyle underlineStyle;
- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range;

/**
 The underline color.
 
 @discussion Default value is nil (same as foreground color).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:7.0
 */
@property (nullable, nonatomic, strong, readwrite) UIColor *underlineColor;
- (void)setUnderlineColor:(nullable UIColor *)underlineColor range:(NSRange)range;

/**
 Ligature formation control.
 
 @discussion Default is int value 1. The ligature attribute determines what kinds
 of ligatures should be used when displaying the string. A value of 0 indicates
 that only ligatures essential for proper rendering of text should be used,
 1 indicates that standard ligatures should be used, and 2 indicates that all
 available ligatures should be used. Which ligatures are standard depends on the
 script and possibly the font.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readwrite) NSNumber *ligature;
- (void)setLigature:(nullable NSNumber *)ligature range:(NSRange)range;

/**
 The text effect.
 
 @discussion Default is nil (no effect). The only currently supported value
 is NSTextEffectLetterpressStyle.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nullable, nonatomic, strong, readwrite) NSString *textEffect;
- (void)setTextEffect:(nullable NSString *)textEffect range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 The skew to be applied to glyphs.
 
 @discussion Default is 0 (no skew).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nullable, nonatomic, strong, readwrite) NSNumber *obliqueness;
- (void)setObliqueness:(nullable NSNumber *)obliqueness range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 The log of the expansion factor to be applied to glyphs.
 
 @discussion Default is 0 (no expansion).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nullable, nonatomic, strong, readwrite) NSNumber *expansion;
- (void)setExpansion:(nullable NSNumber *)expansion range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 The character's offset from the baseline, in points.
 
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nullable, nonatomic, strong, readwrite) NSNumber *baselineOffset;
- (void)setBaselineOffset:(nullable NSNumber *)baselineOffset range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 Glyph orientation control.
 
 @discussion Default is NO. A value of NO indicates that horizontal glyph forms
 are to be used, YES indicates that vertical glyph forms are to be used.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:4.3  YYKit:6.0
 */
@property (nonatomic, readwrite) BOOL verticalGlyphForm;
- (void)setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range;

/**
 Specifies text language.
 
 @discussion Value must be a NSString containing a locale identifier. Default is
 unset. When this attribute is set to a valid identifier, it will be used to select
 localized glyphs (if supported by the font) and locale-specific line breaking rules.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:7.0  YYKit:7.0
 */
@property (nullable, nonatomic, strong, readwrite) NSString *language;
- (void)setLanguage:(nullable NSString *)language range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 Specifies a bidirectional override or embedding.
 
 @discussion See alse NSWritingDirection and NSWritingDirectionAttributeName.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:7.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readwrite) NSArray<NSNumber *> *writingDirection;
- (void)setWritingDirection:(nullable NSArray<NSNumber *> *)writingDirection range:(NSRange)range;

/**
 An NSParagraphStyle object which is used to specify things like
 line alignment, tab rulers, writing direction, etc.
 
 @discussion Default is nil ([NSParagraphStyle defaultParagraphStyle]).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readwrite) NSParagraphStyle *paragraphStyle;
- (void)setParagraphStyle:(nullable NSParagraphStyle *)paragraphStyle range:(NSRange)range;


#pragma mark - Set paragraph attribute as property
///=============================================================================
/// @name Set paragraph attribute as property
///=============================================================================

/**
 The text alignment (A wrapper for NSParagraphStyle).
 
 @discussion Natural text alignment is realized as left or right alignment
 depending on the line sweep direction of the first script contained in the paragraph.
 @discussion Default is NSTextAlignmentNatural.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) NSTextAlignment alignment;
- (void)setAlignment:(NSTextAlignment)alignment range:(NSRange)range;

/**
 The mode that should be used to break lines (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the line break mode to be used laying out the paragraph's text.
 @discussion Default is NSLineBreakByWordWrapping.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) NSLineBreakMode lineBreakMode;
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;

/**
 The distance in points between the bottom of one line fragment and the top of the next.
 (A wrapper for NSParagraphStyle)
 
 @discussion This value is always nonnegative. This value is included in the line
 fragment heights in the layout manager.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) CGFloat lineSpacing;
- (void)setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;

/**
 The space after the end of the paragraph (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the space (measured in points) added at the
 end of the paragraph to separate it from the following paragraph. This value must
 be nonnegative. The space between paragraphs is determined by adding the previous
 paragraph's paragraphSpacing and the current paragraph's paragraphSpacingBefore.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) CGFloat paragraphSpacing;
- (void)setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range;

/**
 The distance between the paragraph's top and the beginning of its text content.
 (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the space (measured in points) between the
 paragraph's top and the beginning of its text content.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) CGFloat paragraphSpacingBefore;
- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range;

/**
 The indentation of the first line (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the distance (in points) from the leading margin
 of a text container to the beginning of the paragraph's first line. This value
 is always nonnegative.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) CGFloat firstLineHeadIndent;
- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range;

/**
 The indentation of the receiver's lines other than the first. (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the distance (in points) from the leading margin
 of a text container to the beginning of lines other than the first. This value is
 always nonnegative.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) CGFloat headIndent;
- (void)setHeadIndent:(CGFloat)headIndent range:(NSRange)range;

/**
 The trailing indentation (A wrapper for NSParagraphStyle).
 
 @discussion If positive, this value is the distance from the leading margin
 (for example, the left margin in left-to-right text). If 0 or negative, it's the
 distance from the trailing margin.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) CGFloat tailIndent;
- (void)setTailIndent:(CGFloat)tailIndent range:(NSRange)range;

/**
 The receiver's minimum height (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the minimum height in points that any line in
 the receiver will occupy, regardless of the font size or size of any attached graphic.
 This value must be nonnegative.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) CGFloat minimumLineHeight;
- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range;

/**
 The receiver's maximum line height (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the maximum height in points that any line in
 the receiver will occupy, regardless of the font size or size of any attached graphic.
 This value is always nonnegative. Glyphs and graphics exceeding this height will
 overlap neighboring lines; however, a maximum height of 0 implies no line height limit.
 Although this limit applies to the line itself, line spacing adds extra space between adjacent lines.
 @discussion Default is 0 (no limit).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) CGFloat maximumLineHeight;
- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range;

/**
 The line height multiple (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the line break mode to be used laying out the paragraph's text.
 @discussion Default is 0 (no multiple).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) CGFloat lineHeightMultiple;
- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range;

/**
 The base writing direction (A wrapper for NSParagraphStyle).
 
 @discussion If you specify NSWritingDirectionNaturalDirection, the receiver resolves
 the writing direction to either NSWritingDirectionLeftToRight or NSWritingDirectionRightToLeft,
 depending on the direction for the user's `language` preference setting.
 @discussion Default is NSWritingDirectionNatural.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0  YYKit:6.0
 */
@property (nonatomic, readwrite) NSWritingDirection baseWritingDirection;
- (void)setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range;

/**
 The paragraph's threshold for hyphenation. (A wrapper for NSParagraphStyle).
 
 @discussion Valid values lie between 0.0 and 1.0 inclusive. Hyphenation is attempted
 when the ratio of the text width (as broken without hyphenation) to the width of the
 line fragment is less than the hyphenation factor. When the paragraph's hyphenation
 factor is 0.0, the layout manager's hyphenation factor is used instead. When both
 are 0.0, hyphenation is disabled.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:6.0
 */
@property (nonatomic, readwrite) float hyphenationFactor;
- (void)setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range;

/**
 The document-wide default tab interval (A wrapper for NSParagraphStyle).
 
 @discussion This property represents the default tab interval in points. Tabs after the
 last specified in tabStops are placed at integer multiples of this distance (if positive).
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:7.0  UIKit:7.0  YYKit:7.0
 */
@property (nonatomic, readwrite) CGFloat defaultTabInterval;
- (void)setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range NS_AVAILABLE_IOS(7_0);


@end

NS_ASSUME_NONNULL_END
