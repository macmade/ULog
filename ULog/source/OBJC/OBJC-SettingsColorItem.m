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
 * @file        OBJC-SettingsColorItem.m
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>

#if !defined( TARGET_OS_IOS ) || TARGET_OS_IOS == 0

@implementation ULogSettingsColorItem

- ( instancetype )initWithLabel: ( NSString * )label colors: ( ULogMessageColors * )colors changedSelector: ( SEL )selector
{
    if( ( self = [ super init ] ) )
    {
        self.label           = label;
        self.colors          = [ colors copy ];
        self.changedSelector = selector;
        
        [ self.colors addObserver: self forKeyPath: @"backgroundColor" options: NSKeyValueObservingOptionNew context: NULL ];
        [ self.colors addObserver: self forKeyPath: @"foregroundColor" options: NSKeyValueObservingOptionNew context: NULL ];
        [ self.colors addObserver: self forKeyPath: @"processColor"    options: NSKeyValueObservingOptionNew context: NULL ];
        [ self.colors addObserver: self forKeyPath: @"timeColor"       options: NSKeyValueObservingOptionNew context: NULL ];
        [ self.colors addObserver: self forKeyPath: @"sourceColor"     options: NSKeyValueObservingOptionNew context: NULL ];
        [ self.colors addObserver: self forKeyPath: @"levelColor"      options: NSKeyValueObservingOptionNew context: NULL ];
        [ self.colors addObserver: self forKeyPath: @"messageColor"    options: NSKeyValueObservingOptionNew context: NULL ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ self.colors removeObserver: self forKeyPath: @"backgroundColor" ];
    [ self.colors removeObserver: self forKeyPath: @"foregroundColor" ];
    [ self.colors removeObserver: self forKeyPath: @"processColor" ];
    [ self.colors removeObserver: self forKeyPath: @"timeColor" ];
    [ self.colors removeObserver: self forKeyPath: @"sourceColor" ];
    [ self.colors removeObserver: self forKeyPath: @"levelColor" ];
    [ self.colors removeObserver: self forKeyPath: @"messageColor" ];
}

- ( void )observeValueForKeyPath: ( NSString * )keyPath ofObject: ( id )object change: ( NSDictionary * )change context: ( void * )context
{
    ULogColorTheme * theme;
    
    ( void )keyPath;
    ( void )change;
    ( void )context;
    
    if( object != self.colors || self.changedSelector == NULL )
    {
        return;
    }
    
    theme = [ [ ULogSettings sharedInstance ].colorTheme copy ];
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [ theme performSelector: self.changedSelector withObject: self.colors ];
    #pragma clang diagnostic pop
    
    [ ULogSettings sharedInstance ].colorTheme = theme;
}

@end

#endif
