/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2016 Jean-David Gadina - www.xs-labs.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

/*!
 * @file        ULogMessageColors.m
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>

#if !defined( TARGET_OS_IOS ) || TARGET_OS_IOS == 0

@interface ULogMessageColors()

- ( NSColor * )decodeColorForKey: ( NSString * )key withCoder: ( NSCoder * )coder;
- ( void )encodeColor: ( NSColor * )color forKey: ( NSString * )key withCoder: ( NSCoder * )coder;

@end

@implementation ULogMessageColors

+ ( BOOL )supportsSecureCoding
{
    return YES;
}

- ( instancetype )initWithCoder: ( NSCoder * )coder
{
    if( ( self = [ self init ] ) )
    {
        self.backgroundColor = [ self decodeColorForKey: @"BackgroundColor" withCoder: coder ];
        self.foregroundColor = [ self decodeColorForKey: @"ForegroundColor" withCoder: coder ];
        self.timeColor       = [ self decodeColorForKey: @"TimeColor"       withCoder: coder ];
        self.sourceColor     = [ self decodeColorForKey: @"SourceColor"     withCoder: coder ];
        self.levelColor      = [ self decodeColorForKey: @"LevelColor"      withCoder: coder ];
        self.messageColor    = [ self decodeColorForKey: @"MessageColor"    withCoder: coder ];
    }
    
    return self;
}

- ( instancetype )copyWithZone: ( NSZone * )zone
{
    ULogMessageColors * colors;
    
    colors = [ [ [ self class ] allocWithZone: zone ] init ];
    
    colors.backgroundColor = [ self.backgroundColor copy ];
    colors.foregroundColor = [ self.foregroundColor copy ];
    colors.timeColor       = [ self.timeColor copy ];
    colors.sourceColor     = [ self.sourceColor copy ];
    colors.levelColor      = [ self.levelColor copy ];
    colors.messageColor    = [ self.messageColor copy ];
    
    return colors;
}

- ( void )encodeWithCoder: ( NSCoder * )coder
{
    [ self encodeColor: self.backgroundColor forKey: @"BackgroundColor" withCoder: coder ];
    [ self encodeColor: self.foregroundColor forKey: @"ForegroundColor" withCoder: coder ];
    [ self encodeColor: self.timeColor       forKey: @"TimeColor"       withCoder: coder ];
    [ self encodeColor: self.sourceColor     forKey: @"SourceColor"     withCoder: coder ];
    [ self encodeColor: self.levelColor      forKey: @"LevelColor"      withCoder: coder ];
    [ self encodeColor: self.messageColor    forKey: @"MessageColor"    withCoder: coder ];
}

- ( NSColor * )decodeColorForKey: ( NSString * )key withCoder: ( NSCoder * )coder
{
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
    
    r = ( CGFloat )[ coder decodeDoubleForKey: [ key stringByAppendingString: @"R" ] ];
    g = ( CGFloat )[ coder decodeDoubleForKey: [ key stringByAppendingString: @"G" ] ];
    b = ( CGFloat )[ coder decodeDoubleForKey: [ key stringByAppendingString: @"B" ] ];
    a = ( CGFloat )[ coder decodeDoubleForKey: [ key stringByAppendingString: @"A" ] ];
    
    return [ NSColor colorWithDeviceRed: r green: g blue: b alpha: a ];
}

- ( void )encodeColor: ( NSColor * )color forKey: ( NSString * )key withCoder: ( NSCoder * )coder
{
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
    
    color = [ color colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
    r     = 0.0;
    g     = 0.0;
    b     = 0.0;
    a     = 0.0;
    
    [ color getRed: &r green: &g blue: &b alpha: &a ];
    
    [ coder encodeDouble: ( double )r forKey: [ key stringByAppendingString: @"R" ] ];
    [ coder encodeDouble: ( double )g forKey: [ key stringByAppendingString: @"G" ] ];
    [ coder encodeDouble: ( double )b forKey: [ key stringByAppendingString: @"B" ] ];
    [ coder encodeDouble: ( double )a forKey: [ key stringByAppendingString: @"A" ] ];
}

@end

#endif
