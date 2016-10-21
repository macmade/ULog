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
 * @file        Settings.m
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>

#if !defined( TARGET_OS_IOS ) || TARGET_OS_IOS == 0

NSString * const ULogSettingsKeyFontName        = @"FontName";
NSString * const ULogSettingsKeyFontSize        = @"FontSize";
NSString * const ULogSettingsKeyBackgroundColor = @"BackgroundColor";
NSString * const ULogSettingsKeyForegoundColor  = @"ForegoundColor";
NSString * const ULogSettingsKeyTimeColor       = @"TimeColor";
NSString * const ULogSettingsKeySourceColor     = @"SourceColor";
NSString * const ULogSettingsKeyLevelColor      = @"LevelColor";
NSString * const ULogSettingsKeyMessageColor    = @"MessageColor";
NSString * const ULogSettingsKeyShowC           = @"ShowC";
NSString * const ULogSettingsKeyShowCXX         = @"ShowCXX";
NSString * const ULogSettingsKeyShowOBJC        = @"ShowOBJC";
NSString * const ULogSettingsKeyShowOBJCXX      = @"ShowOBJCXX";
NSString * const ULogSettingsKeyShowASL         = @"ShowASL";
NSString * const ULogSettingsKeyShowEmergency   = @"ShowEmergency";
NSString * const ULogSettingsKeyShowAlert       = @"ShowAlert";
NSString * const ULogSettingsKeyShowCritical    = @"ShowCritical";
NSString * const ULogSettingsKeyShowError       = @"ShowError";
NSString * const ULogSettingsKeyShowWarning     = @"ShowWarning";
NSString * const ULogSettingsKeyShowNotice      = @"ShowNotice";
NSString * const ULogSettingsKeyShowInfo        = @"ShowInfo";
NSString * const ULogSettingsKeyShowDebug       = @"ShowDebug";

NSString * const ULogSettingsNotificationDefaultsChanged  = @"ULogSettingsNotificationDefaultsChanged";
NSString * const ULogSettingsNotificationDefaultsRestored = @"ULogSettingsNotificationDefaultsRestored";

@interface ULogSettings()

@property( atomic, readwrite, strong ) NSUserDefaults * defaults;

- ( NSColor * )colorForKey: ( NSString * )key;
- ( void )setColor: ( NSColor * )color forKey: ( NSString * )key;
- ( void )synchronizeDefaultsAndNotifyForKey: ( NSString * )key;
- ( NSString * )propertyNameFromSetter: ( SEL )setter;

@end

@implementation ULogSettings

+ ( instancetype )sharedInstance
{
    static dispatch_once_t once;
    static id              instance = nil;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            instance = [ self new ];
        }
    );
    
    return instance;
}

- ( instancetype )init
{
    if( ( self = [ super init ] ) )
    {
        self.defaults = [ [ NSUserDefaults alloc ] initWithSuiteName: @"com.xs-labs.ULog" ];
    }
    
    return self;
}

- ( NSString * )fontName
{
    NSString * name;
    
    @synchronized( self )
    {
        name = [ self.defaults objectForKey: ULogSettingsKeyFontName ];
        
        return ( name ) ? name : @"Consolas";
    }
}

- ( CGFloat )fontSize
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyFontSize ] )
        {
            return ( CGFloat )[ self.defaults doubleForKey: ULogSettingsKeyFontSize ];
        }
        
        return 11.0;
    }
}

- ( NSColor * )backgroundColor
{
    NSColor * color;
    
    @synchronized( self )
    {
        color = [ self colorForKey: ULogSettingsKeyBackgroundColor ];
        
        return ( color ) ? color : ULOG_HEXCOLOR( 0x161A1D, 1 );
    }
}

- ( NSColor * )foregoundColor
{
    NSColor * color;
    
    @synchronized( self )
    {
        color = [ self colorForKey: ULogSettingsKeyForegoundColor ];
        
        return ( color ) ? color : ULOG_HEXCOLOR( 0x6C6C6C, 1 );
    }
}

- ( NSColor * )timeColor
{
    NSColor * color;
    
    @synchronized( self )
    {
        color = [ self colorForKey: ULogSettingsKeyTimeColor ];
        
        return ( color ) ? color : ULOG_HEXCOLOR( 0x5A773C, 1 );
    }
}

- ( NSColor * )sourceColor
{
    NSColor * color;
    
    @synchronized( self )
    {
        color = [ self colorForKey: ULogSettingsKeySourceColor ];
        
        return ( color ) ? color : ULOG_HEXCOLOR( 0x5EA09F, 1 );
    }
}

- ( NSColor * )levelColor
{
    NSColor * color;
    
    @synchronized( self )
    {
        color = [ self colorForKey: ULogSettingsKeyLevelColor ];
        
        return ( color ) ? color : ULOG_HEXCOLOR( 0x996633, 1 );
    }
}

- ( NSColor * )messageColor
{
    NSColor * color;
    
    @synchronized( self )
    {
        color = [ self colorForKey: ULogSettingsKeyMessageColor ];
        
        return ( color ) ? color : ULOG_HEXCOLOR( 0xBFBFBF, 1 );
    }
}

- ( BOOL )showC
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowC ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowC ];
        }
        
        return YES;
    }
}

- ( BOOL )showCXX
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowCXX ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowCXX ];
        }
        
        return YES;
    }
}

- ( BOOL )showOBJC
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowOBJC ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowOBJC ];
        }
        
        return YES;
    }
}

- ( BOOL )showOBJCXX
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowOBJCXX ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowOBJCXX ];
        }
        
        return YES;
    }
}

- ( BOOL )showASL
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowASL ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowASL ];
        }
        
        return YES;
    }
}

- ( BOOL )showEmergency
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowEmergency ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowEmergency ];
        }
        
        return YES;
    }
}

- ( BOOL )showAlert
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowAlert ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowAlert ];
        }
        
        return YES;
    }
}

- ( BOOL )showCritical
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowCritical ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowCritical ];
        }
        
        return YES;
    }
}

- ( BOOL )showError
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowError ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowError ];
        }
        
        return YES;
    }
}

- ( BOOL )showWarning
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowWarning ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowWarning ];
        }
        
        return YES;
    }
}

- ( BOOL )showNotice
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowNotice ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowNotice ];
        }
        
        return YES;
    }
}

- ( BOOL )showInfo
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowInfo ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowInfo ];
        }
        
        return YES;
    }
}

- ( BOOL )showDebug
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowDebug ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowDebug ];
        }
        
        return YES;
    }
}

- ( void )setFontName: ( NSString * )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setObject: value forKey: ULogSettingsKeyFontName ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyFontName ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setFontSize: ( CGFloat )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setDouble: ( double )value forKey: ULogSettingsKeyFontSize ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyFontSize ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setBackgroundColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self setColor: value forKey: ULogSettingsKeyBackgroundColor ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyBackgroundColor ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setForegoundColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self setColor: value forKey: ULogSettingsKeyForegoundColor ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyForegoundColor ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setTimeColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self setColor: value forKey: ULogSettingsKeyTimeColor ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyTimeColor ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setSourceColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self setColor: value forKey: ULogSettingsKeySourceColor ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeySourceColor ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setLevelColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self setColor: value forKey: ULogSettingsKeyLevelColor ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyLevelColor ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setMessageColor: ( NSColor * )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self setColor: value forKey: ULogSettingsKeyMessageColor ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyMessageColor ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowC: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowC ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowC ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowCXX: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowCXX ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowCXX ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowOBJC: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowOBJC ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowOBJC ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowOBJCXX: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowOBJCXX ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowOBJCXX ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowASL: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowASL ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowASL ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowEmergency: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowEmergency ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowEmergency ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowAlert: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowAlert ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowAlert ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowCritical: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowCritical ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowCritical ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowError: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowError ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowError ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowWarning: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowWarning ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowWarning ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowNotice: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowNotice ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowNotice ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowInfo: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowInfo ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowInfo ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowDebug: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowDebug ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowDebug ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( NSColor * )colorForKey: ( NSString * )key
{
    CGFloat    r;
    CGFloat    g;
    CGFloat    b;
    NSString * kr;
    NSString * kg;
    NSString * kb;
    
    @synchronized( self )
    {
        kr = [ key stringByAppendingString: @"R" ];
        kg = [ key stringByAppendingString: @"G" ];
        kb = [ key stringByAppendingString: @"B" ];
        
        if( [ self.defaults objectForKey: kr ] == nil )
        {
            return nil;
        }
        
        if( [ self.defaults objectForKey: kg ] == nil )
        {
            return nil;
        }
        
        if( [ self.defaults objectForKey: kb ] == nil )
        {
            return nil;
        }
        
        r = ( CGFloat )[ self.defaults doubleForKey: kr ];
        g = ( CGFloat )[ self.defaults doubleForKey: kg ];
        b = ( CGFloat )[ self.defaults doubleForKey: kb ];
        
        return [ NSColor colorWithDeviceRed: r green: g blue: b alpha: 1.0 ];
    }
}

- ( void )setColor: ( NSColor * )color forKey: ( NSString * )key
{
    CGFloat    r;
    CGFloat    g;
    CGFloat    b;
    NSString * kr;
    NSString * kg;
    NSString * kb;
    
    @synchronized( self )
    {
        r     = 0.0;
        g     = 0.0;
        b     = 0.0;
        kr    = [ key stringByAppendingString: @"R" ];
        kg    = [ key stringByAppendingString: @"G" ];
        kb    = [ key stringByAppendingString: @"B" ];
        color = [ color colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
        
        [ color getRed: &r green: &g blue: &b alpha: NULL ];
        [ self.defaults setDouble: ( double )r forKey: kr ];
        [ self.defaults setDouble: ( double )g forKey: kg ];
        [ self.defaults setDouble: ( double )b forKey: kb ];
    }
}

- ( void )restoreDefaults
{
    id key;
    
    @synchronized( self )
    {
        for( key in [ self.defaults dictionaryRepresentation ] )
        {
            [ self.defaults removeObjectForKey: key ];
        }
        
        [ self.defaults synchronize ];
        [ [ NSNotificationCenter defaultCenter ] postNotificationName: ULogSettingsNotificationDefaultsRestored object: nil userInfo: nil ];
    }
}

- ( void )synchronizeDefaultsAndNotifyForKey: ( NSString * )key
{
    [ self.defaults synchronize ];
    [ [ NSNotificationCenter defaultCenter ] postNotificationName: ULogSettingsNotificationDefaultsChanged object: key userInfo: nil ];
}

- ( NSString * )propertyNameFromSetter: ( SEL )setter
{
    NSString * set;
    NSString * name;
    
    if( setter == nil )
    {
        return @"";
    }
    
    set = NSStringFromSelector( setter );
    
    if( [ set hasPrefix: @"set" ] && [ set hasSuffix: @":" ] )
    {
        name = [ set substringFromIndex: 4 ];
        name = [ name substringToIndex: name.length - 1 ];
        name = [ [ set substringWithRange: NSMakeRange( 3, 1 ) ].lowercaseString stringByAppendingString: name ];
    }
    
    if( name == nil )
    {
        return @"";
    }
    
    return name;
}

@end

#endif
