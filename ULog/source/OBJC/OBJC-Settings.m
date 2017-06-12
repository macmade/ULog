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
 * @file        OBJC-Settings.m
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>

#if !defined( TARGET_OS_IOS ) || TARGET_OS_IOS == 0

#import <objc/runtime.h>

NSString * const ULogSettingsKeyFontName        = @"FontName";
NSString * const ULogSettingsKeyFontSize        = @"FontSize";
NSString * const ULogSettingsKeyColorTheme      = @"ColorTheme";
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
NSString * const ULogSettingsKeyShowProcess     = @"ShowProcess";
NSString * const ULogSettingsKeyShowTime        = @"ShowTime";
NSString * const ULogSettingsKeyShowSource      = @"ShowSource";
NSString * const ULogSettingsKeyShowLevel       = @"ShowLevel";
NSString * const ULogSettingsKeyShowIcon        = @"ShowIcon";

NSString * const ULogSettingsNotificationDefaultsChanged  = @"ULogSettingsNotificationDefaultsChanged";
NSString * const ULogSettingsNotificationDefaultsRestored = @"ULogSettingsNotificationDefaultsRestored";

@interface ULogSettings()

@property( atomic, readwrite, strong ) NSUserDefaults * defaults;
@property( atomic, readwrite, strong ) ULogColorTheme * cachedColorTheme;

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
        self.defaults = [ NSUserDefaults new ];
        
        [ self.defaults addSuiteNamed: @"com.xs-labs.ULog" ];
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

- ( ULogColorTheme * )colorTheme
{
    NSData         * data;
    ULogColorTheme * theme;
    
    @synchronized( self )
    {
        if( self.cachedColorTheme )
        {
            return self.cachedColorTheme;
        }
        
        theme = nil;
        
        if( [ self.defaults objectForKey: ULogSettingsKeyColorTheme ] )
        {
            data  = [ self.defaults objectForKey: ULogSettingsKeyColorTheme ];
            theme = [ NSKeyedUnarchiver unarchiveObjectWithData: data ];
        }
        
        self.cachedColorTheme = ( theme ) ? theme : [ ULogColorTheme defaultTheme ];
        
        return self.cachedColorTheme;
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

- ( BOOL )showProcess
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowProcess ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowProcess ];
        }
        
        return YES;
    }
}

- ( BOOL )showTime
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowTime ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowTime ];
        }
        
        return YES;
    }
}

- ( BOOL )showSource
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowSource ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowSource ];
        }
        
        return YES;
    }
}

- ( BOOL )showLevel
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowLevel ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowLevel ];
        }
        
        return YES;
    }
}

- ( BOOL )showIcon
{
    @synchronized( self )
    {
        if( [ self.defaults objectForKey: ULogSettingsKeyShowIcon ] )
        {
            return [ self.defaults boolForKey: ULogSettingsKeyShowIcon ];
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

- ( void )setColorTheme: ( ULogColorTheme * )value
{
    NSData * data;
    
    @synchronized( self )
    {
        data = [ NSKeyedArchiver archivedDataWithRootObject: value ];
        
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self setCachedColorTheme: value ];
        [ self.defaults setObject: data forKey: ULogSettingsKeyColorTheme ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyColorTheme ];
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

- ( void )setShowProcess: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowProcess ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowProcess ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowTime: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowTime ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowTime ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowSource: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowSource ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowSource ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowLevel: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowLevel ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowLevel ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
    }
}

- ( void )setShowIcon: ( BOOL )value
{
    @synchronized( self )
    {
        [ self willChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
        [ self.defaults setBool: value forKey: ULogSettingsKeyShowIcon ];
        [ self synchronizeDefaultsAndNotifyForKey: ULogSettingsKeyShowIcon ];
        [ self didChangeValueForKey: [ self propertyNameFromSetter: _cmd ] ];
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
        
        self.cachedColorTheme = nil;
        
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
