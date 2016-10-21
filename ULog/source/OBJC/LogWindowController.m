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
 * @file        LogWindowController.m
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>

#if !defined( TARGET_OS_IOS ) || TARGET_OS_IOS == 0

#define HEXCOLOR( c, a )    [ NSColor   colorWithDeviceRed: ( ( CGFloat )( ( c >> 16 ) & 0x0000FF ) ) / ( CGFloat )255  \
                                        green:              ( ( CGFloat )( ( c >>  8 ) & 0x0000FF ) ) / ( CGFloat )255  \
                                        blue:               ( ( CGFloat )( ( c       ) & 0x0000FF ) ) / ( CGFloat )255  \
                                        alpha:              ( CGFloat )a                                                \
                            ]

static void init( void ) __attribute__( ( constructor ) );
static void init( void )
{
    [ ULogLogWindowController sharedInstance ];
}

@interface ULogLogWindowController()

@property( atomic, readwrite, strong ) ULogLogger         * logger;
@property( atomic, readwrite, strong ) NSAttributedString * log;
@property( atomic, readwrite, strong ) NSAttributedString * lf;
@property( atomic, readwrite, strong ) NSDictionary       * textAttributes;
@property( atomic, readwrite, strong ) NSDictionary       * timeAttributes;
@property( atomic, readwrite, strong ) NSDictionary       * sourceAttributes;
@property( atomic, readwrite, strong ) NSDictionary       * levelAttributes;
@property( atomic, readwrite, strong ) NSDictionary       * messageAttributes;
@property( atomic, readwrite, strong ) NSString           * searchText;
@property( atomic, readwrite, assign ) BOOL                 shown;
@property( atomic, readwrite, assign ) BOOL                 filterShowC;
@property( atomic, readwrite, assign ) BOOL                 filterShowCXX;
@property( atomic, readwrite, assign ) BOOL                 filterShowOBJC;
@property( atomic, readwrite, assign ) BOOL                 filterShowOBJCXX;
@property( atomic, readwrite, assign ) BOOL                 filterShowASL;
@property( atomic, readwrite, assign ) BOOL                 filterShowEmergency;
@property( atomic, readwrite, assign ) BOOL                 filterShowAlert;
@property( atomic, readwrite, assign ) BOOL                 filterShowCritical;
@property( atomic, readwrite, assign ) BOOL                 filterShowError;
@property( atomic, readwrite, assign ) BOOL                 filterShowWarning;
@property( atomic, readwrite, assign ) BOOL                 filterShowNotice;
@property( atomic, readwrite, assign ) BOOL                 filterShowInfo;
@property( atomic, readwrite, assign ) BOOL                 filterShowDebug;

@property( atomic, readwrite, strong ) IBOutlet NSTextView * textView;

- ( void )refresh;
- ( NSAttributedString * )stringForMessage: ( ULogMessage * )message;

@end

@implementation ULogLogWindowController

+ ( instancetype )sharedInstance
{
    static dispatch_once_t once;
    static id              instance = nil;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            instance = [ [ self alloc ] initWithLogger: [ ULogLogger sharedInstance ] ];
        }
    );
    
    return instance;
}

- ( instancetype )initWithLogger: ( ULogLogger * )logger
{
    if( logger == nil )
    {
        return nil;
    }
    
    if( ( self = [ self init ] ) )
    {
        self.logger = logger;
        
        [ NSThread detachNewThreadSelector: @selector( refresh ) toTarget: self withObject: nil ];
    }
    
    return self;
}

- ( instancetype )init
{
    return [ self initWithWindowNibName: NSStringFromClass( [ self class ] ) ];
}

- ( instancetype )initWithWindowNibName: ( NSString * )name
{
    if( ( self = [ super initWithWindowNibName: name ] ) )
    {
        self.backgroundColor    = HEXCOLOR( 0x161A1D, 1 );
        self.textColor          = HEXCOLOR( 0x6C6C6C, 1 );
        self.timeColor          = HEXCOLOR( 0x5A773C, 1 );
        self.sourceColor        = HEXCOLOR( 0x5EA09F, 1 );
        self.levelColor         = HEXCOLOR( 0x996633, 1 );
        self.messageColor       = HEXCOLOR( 0xBFBFBF, 1 );
        self.log                = [ NSMutableAttributedString new ];
        self.lf                 = [ [ NSAttributedString alloc ] initWithString: @"\n" attributes: nil ];
        self.font               = [ NSFont fontWithName: @"Consolas" size: 11 ];
        
        [ self addObserver: self forKeyPath: @"filterShowC"         options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowCXX"       options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowOBJC"      options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowOBJCXX"    options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowASL"       options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowEmergency" options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowAlert"     options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowCritical"  options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowError"     options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowWarning"   options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowNotice"    options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowInfo"      options: NSKeyValueObservingOptionNew context: nil ];
        [ self addObserver: self forKeyPath: @"filterShowDebug"     options: NSKeyValueObservingOptionNew context: nil ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ self removeObserver: self forKeyPath: @"filterShowC" ];
    [ self removeObserver: self forKeyPath: @"filterShowCXX" ];
    [ self removeObserver: self forKeyPath: @"filterShowOBJC" ];
    [ self removeObserver: self forKeyPath: @"filterShowOBJCXX" ];
    [ self removeObserver: self forKeyPath: @"filterShowASL" ];
    [ self removeObserver: self forKeyPath: @"filterShowEmergency" ];
    [ self removeObserver: self forKeyPath: @"filterShowAlert" ];
    [ self removeObserver: self forKeyPath: @"filterShowCritical" ];
    [ self removeObserver: self forKeyPath: @"filterShowError" ];
    [ self removeObserver: self forKeyPath: @"filterShowWarning" ];
    [ self removeObserver: self forKeyPath: @"filterShowNotice" ];
    [ self removeObserver: self forKeyPath: @"filterShowInfo" ];
    [ self removeObserver: self forKeyPath: @"filterShowDebug" ];
}

- ( void )observeValueForKeyPath: ( NSString * )keyPath ofObject: ( id )object change: ( NSDictionary< NSKeyValueChangeKey, id > * )change context: ( void * )context
{
    if( object == self )
    {
        if( [ keyPath isEqualToString: @"filterShowC" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowC forKey: @"ULogFilterShowC" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowCXX" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowCXX forKey: @"ULogFilterShowCXX" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowOBJC" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowOBJC forKey: @"ULogFilterShowOBJC" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowOBJCXX" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowOBJCXX forKey: @"ULogFilterShowOBJCXX" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowASL" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowASL forKey: @"ULogFilterShowASL" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowEmergency" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowASL forKey: @"ULogFilterShowEmergency" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowAlert" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowASL forKey: @"ULogFilterShowAlert" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowCritical" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowASL forKey: @"ULogFilterShowCritical" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowError" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowASL forKey: @"ULogFilterShowError" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowWarning" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowASL forKey: @"ULogFilterShowWarning" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowNotice" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowASL forKey: @"ULogFilterShowNotice" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowInfo" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowASL forKey: @"ULogFilterShowInfo" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
        
        if( [ keyPath isEqualToString: @"filterShowDebug" ] )
        {
            [ [ NSUserDefaults standardUserDefaults ] setBool: self.filterShowASL forKey: @"ULogFilterShowDebug" ];
            [ [ NSUserDefaults standardUserDefaults ] synchronize ];
            
            return;
        }
    }
    
    [ super observeValueForKeyPath: keyPath ofObject: object change: change context: context ];
}

- ( void )windowDidLoad
{
    self.textAttributes                 = @{ NSForegroundColorAttributeName : self.textColor,    NSFontAttributeName : self.font };
    self.timeAttributes                 = @{ NSForegroundColorAttributeName : self.timeColor,    NSFontAttributeName : self.font };
    self.sourceAttributes               = @{ NSForegroundColorAttributeName : self.sourceColor,  NSFontAttributeName : self.font };
    self.levelAttributes                = @{ NSForegroundColorAttributeName : self.levelColor,   NSFontAttributeName : self.font };
    self.messageAttributes              = @{ NSForegroundColorAttributeName : self.messageColor, NSFontAttributeName : self.font };
    self.window.alphaValue              = 0.95;
    self.textView.drawsBackground       = YES;
    self.textView.backgroundColor       = self.backgroundColor;
    self.textView.textContainerInset    = NSMakeSize( 5.0, 10.0 );
    self.window.title                   = [ NSString stringWithFormat: @"%@ - Logs", [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ] ];
    
    if( [ [ NSUserDefaults standardUserDefaults ] objectForKey: @"ULogFilterShowC" ] == nil )
    {
        self.filterShowC            = YES;
        self.filterShowCXX          = YES;
        self.filterShowOBJC         = YES;
        self.filterShowOBJCXX       = YES;
        self.filterShowASL          = YES;
        self.filterShowEmergency    = YES;
        self.filterShowAlert        = YES;
        self.filterShowCritical     = YES;
        self.filterShowError        = YES;
        self.filterShowWarning      = YES;
        self.filterShowNotice       = YES;
        self.filterShowInfo         = YES;
        self.filterShowDebug        = YES;
    }
    else
    {
        self.filterShowC            = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowC" ];
        self.filterShowCXX          = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowCXX" ];
        self.filterShowOBJC         = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowOBJC" ];
        self.filterShowOBJCXX       = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowOBJCXX" ];
        self.filterShowASL          = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowASL" ];
        self.filterShowEmergency    = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowEmergency" ];
        self.filterShowAlert        = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowAlert" ];
        self.filterShowCritical     = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowCritical" ];
        self.filterShowError        = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowError" ];
        self.filterShowWarning      = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowWarning" ];
        self.filterShowNotice       = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowNotice" ];
        self.filterShowInfo         = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowInfo" ];
        self.filterShowDebug        = [ [ NSUserDefaults standardUserDefaults ] boolForKey: @"ULogFilterShowDebug" ];
    }
}

- ( void )refresh
{
    NSArray< ULogMessage * >  * messages;
    ULogMessage               * message;
    NSMutableAttributedString * log;
    NSPredicate               * predicate;
    
    while( 1 )
    {
        messages = self.logger.messages;
        log      = [ NSMutableAttributedString new ];
        
        if( messages.count && self.shown == NO )
        {
            self.shown = YES;
            
            dispatch_sync
            (
                dispatch_get_main_queue(),
                ^( void )
                {
                    [ self showWindow: nil ];
                }
            );
        }
        
        if( self.searchText.length )
        {
            predicate = [ NSPredicate predicateWithFormat: @"message contains[c] %@", self.searchText ];
            messages  = [ messages filteredArrayUsingPredicate: predicate ];
        }
        
        for( message in messages )
        {
            if( message.source == ULogMessageSourceC && self.filterShowC == NO )
            {
                continue;
            }
            
            if( message.source == ULogMessageSourceCXX && self.filterShowCXX == NO )
            {
                continue;
            }
            
            if( message.source == ULogMessageSourceOBJC && self.filterShowOBJC == NO )
            {
                continue;
            }
            
            if( message.source == ULogMessageSourceOBJCXX && self.filterShowOBJCXX == NO )
            {
                continue;
            }
            
            if( message.source == ULogMessageSourceASL && self.filterShowASL == NO )
            {
                continue;
            }
            
            if( message.level == ULogMessageLevelEmergency && self.filterShowEmergency == NO )
            {
                continue;
            }
            
            if( message.level == ULogMessageLevelAlert && self.filterShowAlert == NO )
            {
                continue;
            }
            
            if( message.level == ULogMessageLevelCritical && self.filterShowCritical == NO )
            {
                continue;
            }
            
            if( message.level == ULogMessageLevelError && self.filterShowError == NO )
            {
                continue;
            }
            
            if( message.level == ULogMessageLevelWarning && self.filterShowWarning == NO )
            {
                continue;
            }
            
            if( message.level == ULogMessageLevelNotice && self.filterShowNotice == NO )
            {
                continue;
            }
            
            if( message.level == ULogMessageLevelInfo && self.filterShowInfo == NO )
            {
                continue;
            }
            
            if( message.level == ULogMessageLevelDebug && self.filterShowDebug == NO )
            {
                continue;
            }
            
            [ log appendAttributedString: [ self stringForMessage: message ] ];
        }
        
        dispatch_sync
        (
            dispatch_get_main_queue(),
            ^( void )
            {
                self.log = log;
            }
        );
        
        [ NSThread sleepForTimeInterval: 0.5 ];
    }
}

- ( NSAttributedString * )stringForMessage: ( ULogMessage * )message
{
    NSMutableAttributedString * str;
    NSAttributedString        * time;
    NSAttributedString        * source;
    NSAttributedString        * level;
    NSAttributedString        * text;
    
    str    = [ NSMutableAttributedString new ];
    time   = [ [ NSAttributedString alloc ] initWithString: message.timeString   attributes: self.timeAttributes ];
    source = [ [ NSAttributedString alloc ] initWithString: message.sourceString attributes: self.sourceAttributes ];
    level  = [ [ NSAttributedString alloc ] initWithString: message.levelString  attributes: self.levelAttributes ];
    text   = [ [ NSAttributedString alloc ] initWithString: message.message      attributes: self.messageAttributes ];
    
    [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"[ " attributes: self.textAttributes ] ];
    [ str appendAttributedString: time ];
    [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @" ]> " attributes: self.textAttributes ] ];
    [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"[ " attributes: self.textAttributes ] ];
    [ str appendAttributedString: source ];
    [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @" ]> " attributes: self.textAttributes ] ];
    [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"[ " attributes: self.textAttributes ] ];
    [ str appendAttributedString: level ];
    [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @" ]> " attributes: self.textAttributes ] ];
    [ str appendAttributedString: text ];
    [ str appendAttributedString: self.lf ];
    
    return str;
}

@end

#endif
