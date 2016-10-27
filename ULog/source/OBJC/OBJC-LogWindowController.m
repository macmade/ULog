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

static void init( void ) __attribute__( ( constructor ) );
static void init( void )
{
    [ ULogLogWindowController sharedInstance ];
}

@interface ULogLogWindowController()

@property( atomic, readwrite, strong ) ULogLogger                   * logger;
@property( atomic, readwrite, strong ) ULogMessage                  * lastMessage;
@property( atomic, readwrite, strong ) ULogSettingsWindowController * settingsWindowController;
@property( atomic, readwrite, strong ) NSAttributedString           * log;
@property( atomic, readwrite, strong ) NSAttributedString           * lf;
@property( atomic, readwrite, strong ) NSString                     * searchText;
@property( atomic, readwrite, strong ) NSString                     * pauseButtonTitle;
@property( atomic, readwrite, assign ) BOOL                           shown;
@property( atomic, readwrite, assign ) BOOL                           paused;
@property( atomic, readwrite, assign ) BOOL                           editable;

@property( atomic, readwrite, strong ) IBOutlet NSTextView * textView;

- ( IBAction )clear: ( id )sender;
- ( IBAction )togglePause: ( id )sender;
- ( IBAction )save: ( id )sender;
- ( IBAction )saveAsText: ( id )sender;
- ( IBAction )saveAsRTF: ( id )sender;
- ( IBAction )showSettings: ( id )sender;
- ( void )updateSettings;
- ( void )updateTitleWithMessageCount: ( NSUInteger )count;
- ( void )refresh;
- ( void )renderMessages: ( NSArray * )messages until: ( ULogMessage * )last;
- ( NSAttributedString * )stringForMessage: ( ULogMessage * )message;
- ( NSDictionary * )foregroundAttributesForLevel: ( ULogMessageLevel )level;
- ( NSDictionary * )processAttributesForLevel: ( ULogMessageLevel )level;
- ( NSDictionary * )timeAttributesForLevel: ( ULogMessageLevel )level;
- ( NSDictionary * )sourceAttributesForLevel: ( ULogMessageLevel )level;
- ( NSDictionary * )levelAttributesForLevel: ( ULogMessageLevel )level;
- ( NSDictionary * )messageAttributesForLevel: ( ULogMessageLevel )level;

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

- ( instancetype )initWithCoder: ( NSCoder * )coder
{
    ( void )coder;
    
    return [ [ self class ] sharedInstance ];
}

- ( instancetype )initWithWindowNibName: ( NSString * )name
{
    if( ( self = [ super initWithWindowNibName: name ] ) )
    {
        self.log    = [ NSMutableAttributedString new ];
        self.lf     = [ [ NSAttributedString alloc ] initWithString: @"\n" attributes: nil ];
        
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( updateSettings ) name: ULogSettingsNotificationDefaultsChanged  object: nil ];
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( updateSettings ) name: ULogSettingsNotificationDefaultsRestored object: nil ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

- ( void )windowDidLoad
{
    [ self updateSettings ];
    
    self.textView.textContainerInset    = NSMakeSize( 5.0, 10.0 );
    self.textView.drawsBackground       = YES;
    self.pauseButtonTitle               = @"Pause";
    self.window.alphaValue              = 0.95;
    
    [ self updateTitleWithMessageCount: 0 ];
}

- ( IBAction )clear: ( id )sender
{
    ( void )sender;
    
    @synchronized( self )
    {
        [ self.logger clear ];
        [ self updateTitleWithMessageCount: 0 ];
        
        self.lastMessage = nil;
        self.log         = nil;
    }
}

- ( IBAction )togglePause: ( id )sender
{
    ( void )sender;
    
    @synchronized( self )
    {
        if( self.paused )
        {
            self.paused           = NO;
            self.pauseButtonTitle = @"Pause";
        }
        else
        {
            self.paused           = YES;
            self.pauseButtonTitle = @"Resume";
        }
    }
}

- ( IBAction )save: ( id )sender
{
    NSButton * btn;
    
    btn = ( NSButton * )sender;
    
    if( [ sender isKindOfClass: [ NSButton class ] ] == NO || btn.menu == nil )
    {
        [ self saveAsText: sender ];
        
        return;
    }
    
    [ NSMenu popUpContextMenu: btn.menu withEvent: NSApp.currentEvent forView: btn ];
}

- ( IBAction )saveAsText: ( id )sender
{
    NSSavePanel     * panel;
    NSString        * app;
    NSString        * date;
    NSDateFormatter * formatter;
    
    ( void )sender;
    
    formatter = [ NSDateFormatter new ];
    
    [ formatter setDateFormat: @"yyyy-MM-dd-hh-mm-ss" ];
    
    app   = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ];
    date  = [ formatter stringFromDate: [ NSDate date ] ];
    panel = [ NSSavePanel savePanel ];
    
    [ panel setNameFieldStringValue: [ NSString stringWithFormat: @"ULog-%@-%@.txt", app, date ] ];
    [ panel setCanCreateDirectories: YES ];
    [ panel beginSheetModalForWindow: self.window completionHandler: ^( NSInteger result )
        {
            NSString * path;
            NSData   * data;
            
            if( result != NSFileHandlingPanelOKButton )
            {
                return;
            }
            
            path = panel.URL.path;
            
            if( path == nil )
            {
                return;
            }
            
            data = [ self.log.string dataUsingEncoding: NSUTF8StringEncoding ];
            
            [ data writeToFile: path atomically: YES ];
        }
    ];
}

- ( IBAction )saveAsRTF: ( id )sender
{
    NSSavePanel     * panel;
    NSString        * app;
    NSString        * date;
    NSDateFormatter * formatter;
    
    ( void )sender;
    
    formatter = [ NSDateFormatter new ];
    
    [ formatter setDateFormat: @"yyyy-MM-dd-hh-mm-ss" ];
    
    app   = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ];
    date  = [ formatter stringFromDate: [ NSDate date ] ];
    panel = [ NSSavePanel savePanel ];
    
    [ panel setNameFieldStringValue: [ NSString stringWithFormat: @"ULog-%@-%@.rtf", app, date ] ];
    [ panel setCanCreateDirectories: YES ];
    [ panel beginSheetModalForWindow: self.window completionHandler: ^( NSInteger result )
        {
            NSString           * path;
            NSData             * data;
            NSAttributedString * log;
            
            if( result != NSFileHandlingPanelOKButton )
            {
                return;
            }
            
            path = panel.URL.path;
            
            if( path == nil )
            {
                return;
            }
            
            log  = self.log;
            data = [ log RTFFromRange: NSMakeRange( 0, log.length ) documentAttributes: @{} ];
            
            [ data writeToFile: path atomically: YES ];
        }
    ];
}

- ( IBAction )showSettings: ( id )sender
{
    @synchronized( self )
    {
        if( self.settingsWindowController == nil )
        {
            self.settingsWindowController = [ ULogSettingsWindowController new ];
            
            [ self.settingsWindowController.window center ];
        }
        
        [ self.settingsWindowController.window makeKeyAndOrderFront: sender ];
    }
}

- ( void )updateSettings
{
    @synchronized( self )
    {
        self.textView.backgroundColor = [ ULogSettings sharedInstance ].colorTheme.debugColors.backgroundColor;
    }
}

- ( void )updateTitleWithMessageCount: ( NSUInteger )count
{
    if( count == 0 )
    {
        self.window.title = [ NSString stringWithFormat: @"%@ - Logs", [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ] ];
    }
    else
    {
        self.window.title = [ NSString stringWithFormat: @"%@ - Logs (%lu messages)", [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ], ( unsigned long )count ];
    }
}

- ( void )refresh
{
    NSArray< ULogMessage * > * messages;
    
    while( 1 )
    {
        messages = self.logger.messages;
        
        if( self.paused )
        {
            if( self.log )
            {
                [ self renderMessages: messages until: self.lastMessage ];
            }
            
            [ NSThread sleepForTimeInterval: 0.5 ];
            
            continue;
        }
        
        self.lastMessage = messages.lastObject;
        
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
        
        [ self renderMessages: messages until: nil ];
        [ NSThread sleepForTimeInterval: 0.5 ];
    }
}

- ( void )renderMessages: ( NSArray * )messages until: ( ULogMessage * )last
{
    NSPredicate               * predicate;
    NSMutableAttributedString * log;
    ULogMessage               * message;
    NSUInteger                  i;
        
    log = [ NSMutableAttributedString new ];
    i   = 0;
    
    if( self.searchText.length )
    {
        predicate = [ NSPredicate predicateWithFormat: @"message contains[c] %@", self.searchText ];
        messages  = [ messages filteredArrayUsingPredicate: predicate ];
    }
    
    for( message in messages )
    {
        if( message.source == ULogMessageSourceC && [ ULogSettings sharedInstance ].showC == NO )
        {
            continue;
        }
        
        if( message.source == ULogMessageSourceCXX && [ ULogSettings sharedInstance ].showCXX == NO )
        {
            continue;
        }
        
        if( message.source == ULogMessageSourceOBJC && [ ULogSettings sharedInstance ].showOBJC == NO )
        {
            continue;
        }
        
        if( message.source == ULogMessageSourceOBJCXX && [ ULogSettings sharedInstance ].showOBJCXX == NO )
        {
            continue;
        }
        
        if( message.source == ULogMessageSourceASL && [ ULogSettings sharedInstance ].showASL == NO )
        {
            continue;
        }
        
        if( message.level == ULogMessageLevelEmergency && [ ULogSettings sharedInstance ].showEmergency == NO )
        {
            continue;
        }
        
        if( message.level == ULogMessageLevelAlert && [ ULogSettings sharedInstance ].showAlert == NO )
        {
            continue;
        }
        
        if( message.level == ULogMessageLevelCritical && [ ULogSettings sharedInstance ].showCritical == NO )
        {
            continue;
        }
        
        if( message.level == ULogMessageLevelError && [ ULogSettings sharedInstance ].showError == NO )
        {
            continue;
        }
        
        if( message.level == ULogMessageLevelWarning && [ ULogSettings sharedInstance ].showWarning == NO )
        {
            continue;
        }
        
        if( message.level == ULogMessageLevelNotice && [ ULogSettings sharedInstance ].showNotice == NO )
        {
            continue;
        }
        
        if( message.level == ULogMessageLevelInfo && [ ULogSettings sharedInstance ].showInfo == NO )
        {
            continue;
        }
        
        if( message.level == ULogMessageLevelDebug && [ ULogSettings sharedInstance ].showDebug == NO )
        {
            continue;
        }
        
        i++;
        
        [ log appendAttributedString: [ self stringForMessage: message ] ];
        
        if( last && [ message isEqual: last ] )
        {
            break;
        }
    }
    
    dispatch_sync
    (
        dispatch_get_main_queue(),
        ^( void )
        {
            NSRange r1;
            NSRange r2;
            NSPoint origin;
            double  pos;
            
            @try
            {
                pos = self.textView.enclosingScrollView.verticalScroller.doubleValue;
                r1  = [ self.textView.layoutManager glyphRangeForBoundingRect: [ self.textView visibleRect ] inTextContainer: self.textView.textContainer ];
                r2  = [ self.textView.layoutManager characterRangeForGlyphRange: r1 actualGlyphRange: &r2 ];
                
                self.log = log;
                
                if( fabs( pos - 1 ) < DBL_EPSILON )
                {
                    if( [ [ self.textView.enclosingScrollView documentView ] isFlipped ] )
                    {
                        origin = NSMakePoint
                        (
                            0.0,
                            (
                                NSMaxY( [ [ self.textView.enclosingScrollView documentView ] frame ] )
                              - NSHeight( [ [ self.textView.enclosingScrollView contentView ] bounds ] )
                            )
                        );
                    }
                    else
                    {
                        origin = NSMakePoint( 0.0, 0.0 );
                    }
                 
                    [ [ self.textView.enclosingScrollView documentView ] scrollPoint: origin ];
                }
                else
                {
                    [ self.textView scrollRangeToVisible: r2 ];
                }
                
                [ self updateTitleWithMessageCount: i ];
            }
            @catch( NSException * e )
            {
                ( void )e;
                
                self.log = log;
            }
        }
    );
}

- ( NSAttributedString * )stringForMessage: ( ULogMessage * )message
{
    NSMutableAttributedString * str;
    NSAttributedString        * process;
    NSAttributedString        * time;
    NSAttributedString        * source;
    NSAttributedString        * level;
    NSAttributedString        * text;
    NSDictionary              * fg;
    NSColor                   * bg;
    
    str     = [ NSMutableAttributedString new ];
    process = [ [ NSAttributedString alloc ] initWithString: message.processString attributes: [ self processAttributesForLevel: message.level ] ];
    time    = [ [ NSAttributedString alloc ] initWithString: message.timeString    attributes: [ self timeAttributesForLevel: message.level ] ];
    source  = [ [ NSAttributedString alloc ] initWithString: message.sourceString  attributes: [ self sourceAttributesForLevel: message.level ] ];
    level   = [ [ NSAttributedString alloc ] initWithString: message.levelString   attributes: [ self levelAttributesForLevel: message.level ] ];
    text    = [ [ NSAttributedString alloc ] initWithString: message.message       attributes: [ self messageAttributesForLevel: message.level ] ];
    fg      = [ self foregroundAttributesForLevel: message.level ];
    
    if( [ ULogSettings sharedInstance ].showIcon )
    {
        if( message.level == ULogMessageLevelEmergency )
        {
            [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"💣 " attributes: nil ] ];
        }
        else if( message.level == ULogMessageLevelAlert )
        {
            [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"📛 " attributes: nil ] ];
        }
        else if( message.level == ULogMessageLevelCritical )
        {
            [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"⛔️ " attributes: nil ] ];
        }
        else if( message.level == ULogMessageLevelError )
        {
            [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"❌ " attributes: nil ] ];
        }
        else if( message.level == ULogMessageLevelWarning )
        {
            [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"⚠️ " attributes: nil ] ];
        }
        else if( message.level == ULogMessageLevelNotice )
        {
            [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"❕ " attributes: nil ] ];
        }
        else if( message.level == ULogMessageLevelInfo )
        {
            [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"ℹ️ " attributes: nil ] ];
        }
        else if( message.level == ULogMessageLevelDebug )
        {
            [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: @"🚧 " attributes: nil ] ];
        }
    }
    
    if( [ ULogSettings sharedInstance ].showProcess )
    {
        [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: NSLocalizedString( @"[ ", nil ) attributes: fg ] ];
        [ str appendAttributedString: process ];
        [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: NSLocalizedString( @" ]> ", nil ) attributes: fg ] ];
    }
    
    if( [ ULogSettings sharedInstance ].showTime )
    {
        [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: NSLocalizedString( @"[ ", nil ) attributes: fg ] ];
        [ str appendAttributedString: time ];
        [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: NSLocalizedString( @" ]> ", nil ) attributes: fg ] ];
    }
    
    if( [ ULogSettings sharedInstance ].showSource )
    {
        [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: NSLocalizedString( @"[ ", nil ) attributes: fg ] ];
        [ str appendAttributedString: source ];
        [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: NSLocalizedString( @" ]> ", nil ) attributes: fg ] ];
    }
    
    if( [ ULogSettings sharedInstance ].showLevel )
    {
        [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: NSLocalizedString( @"[ ", nil ) attributes: fg ] ];
        [ str appendAttributedString: level ];
        [ str appendAttributedString: [ [ NSAttributedString alloc ] initWithString: NSLocalizedString( @" ]> ", nil ) attributes: fg ] ];
    }
    
    [ str appendAttributedString: text ];
    [ str appendAttributedString: self.lf ];
    
    switch( message.level )
    {
        case ULogMessageLevelEmergency: bg = [ ULogSettings sharedInstance ].colorTheme.emergencyColors.backgroundColor; break;
        case ULogMessageLevelAlert:     bg = [ ULogSettings sharedInstance ].colorTheme.alertColors.backgroundColor;     break;
        case ULogMessageLevelCritical:  bg = [ ULogSettings sharedInstance ].colorTheme.criticalColors.backgroundColor;  break;
        case ULogMessageLevelError:     bg = [ ULogSettings sharedInstance ].colorTheme.errorColors.backgroundColor;     break;
        case ULogMessageLevelWarning:   bg = [ ULogSettings sharedInstance ].colorTheme.warningColors.backgroundColor;   break;
        case ULogMessageLevelNotice:    bg = [ ULogSettings sharedInstance ].colorTheme.noticeColors.backgroundColor;    break;
        case ULogMessageLevelInfo:      bg = [ ULogSettings sharedInstance ].colorTheme.infoColors.backgroundColor;      break;
        case ULogMessageLevelDebug:     bg = [ ULogSettings sharedInstance ].colorTheme.debugColors.backgroundColor;     break;
        default:                        bg = nil;                                                                        break;
    }
    
    if( bg )
    {
        if( [ ULogSettings sharedInstance ].showIcon )
        {
            [ str addAttribute: NSBackgroundColorAttributeName value: bg range: NSMakeRange( 3, str.length - 3 ) ];
        }
        else
        {
            [ str addAttribute: NSBackgroundColorAttributeName value: bg range: NSMakeRange( 0, str.length ) ];
        }
    }
    
    if( [ ULogSettings sharedInstance ].showIcon && [ ULogSettings sharedInstance ].fontSize < 15 )
    {
        {
            NSMutableParagraphStyle * pStyle;
            
            pStyle = [ [ NSParagraphStyle defaultParagraphStyle ] mutableCopy ];
            
            pStyle.lineHeightMultiple = 0.7;
            
            [ str addAttribute: NSParagraphStyleAttributeName  value: pStyle range: NSMakeRange( 0, str.length ) ];
        }
    }
    
    return str;
}

- ( NSDictionary * )foregroundAttributesForLevel: ( ULogMessageLevel )level
{
    NSFont            * font;
    NSColor           * color;
    
    font = [ NSFont fontWithName: [ ULogSettings sharedInstance ].fontName size: [ ULogSettings sharedInstance ].fontSize ];
    
    switch( level )
    {
        case ULogMessageLevelEmergency: color = [ ULogSettings sharedInstance ].colorTheme.emergencyColors.foregroundColor; break;
        case ULogMessageLevelAlert:     color = [ ULogSettings sharedInstance ].colorTheme.alertColors.foregroundColor;     break;
        case ULogMessageLevelCritical:  color = [ ULogSettings sharedInstance ].colorTheme.criticalColors.foregroundColor;  break;
        case ULogMessageLevelError:     color = [ ULogSettings sharedInstance ].colorTheme.errorColors.foregroundColor;     break;
        case ULogMessageLevelWarning:   color = [ ULogSettings sharedInstance ].colorTheme.warningColors.foregroundColor;   break;
        case ULogMessageLevelNotice:    color = [ ULogSettings sharedInstance ].colorTheme.noticeColors.foregroundColor;    break;
        case ULogMessageLevelInfo:      color = [ ULogSettings sharedInstance ].colorTheme.infoColors.foregroundColor;      break;
        case ULogMessageLevelDebug:     color = [ ULogSettings sharedInstance ].colorTheme.debugColors.foregroundColor;     break;
        default:                        color = nil;                                                                        break;
    }
    
    if( color )
    {
        return @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    }
    
    return @{ NSFontAttributeName : font };
}

- ( NSDictionary * )processAttributesForLevel: ( ULogMessageLevel )level
{
    NSFont            * font;
    NSColor           * color;
    
    font = [ NSFont fontWithName: [ ULogSettings sharedInstance ].fontName size: [ ULogSettings sharedInstance ].fontSize ];
    
    switch( level )
    {
        case ULogMessageLevelEmergency: color = [ ULogSettings sharedInstance ].colorTheme.emergencyColors.processColor; break;
        case ULogMessageLevelAlert:     color = [ ULogSettings sharedInstance ].colorTheme.alertColors.processColor;     break;
        case ULogMessageLevelCritical:  color = [ ULogSettings sharedInstance ].colorTheme.criticalColors.processColor;  break;
        case ULogMessageLevelError:     color = [ ULogSettings sharedInstance ].colorTheme.errorColors.processColor;     break;
        case ULogMessageLevelWarning:   color = [ ULogSettings sharedInstance ].colorTheme.warningColors.processColor;   break;
        case ULogMessageLevelNotice:    color = [ ULogSettings sharedInstance ].colorTheme.noticeColors.processColor;    break;
        case ULogMessageLevelInfo:      color = [ ULogSettings sharedInstance ].colorTheme.infoColors.processColor;      break;
        case ULogMessageLevelDebug:     color = [ ULogSettings sharedInstance ].colorTheme.debugColors.processColor;     break;
        default:                        color = nil;                                                                     break;
    }
    
    if( color )
    {
        return @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    }
    
    return @{ NSFontAttributeName : font };
}

- ( NSDictionary * )timeAttributesForLevel: ( ULogMessageLevel )level
{
    NSFont            * font;
    NSColor           * color;
    
    font = [ NSFont fontWithName: [ ULogSettings sharedInstance ].fontName size: [ ULogSettings sharedInstance ].fontSize ];
    
    switch( level )
    {
        case ULogMessageLevelEmergency: color = [ ULogSettings sharedInstance ].colorTheme.emergencyColors.timeColor; break;
        case ULogMessageLevelAlert:     color = [ ULogSettings sharedInstance ].colorTheme.alertColors.timeColor;     break;
        case ULogMessageLevelCritical:  color = [ ULogSettings sharedInstance ].colorTheme.criticalColors.timeColor;  break;
        case ULogMessageLevelError:     color = [ ULogSettings sharedInstance ].colorTheme.errorColors.timeColor;     break;
        case ULogMessageLevelWarning:   color = [ ULogSettings sharedInstance ].colorTheme.warningColors.timeColor;   break;
        case ULogMessageLevelNotice:    color = [ ULogSettings sharedInstance ].colorTheme.noticeColors.timeColor;    break;
        case ULogMessageLevelInfo:      color = [ ULogSettings sharedInstance ].colorTheme.infoColors.timeColor;      break;
        case ULogMessageLevelDebug:     color = [ ULogSettings sharedInstance ].colorTheme.debugColors.timeColor;     break;
        default:                        color = nil;                                                                  break;
    }
    
    if( color )
    {
        return @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    }
    
    return @{ NSFontAttributeName : font };
}

- ( NSDictionary * )sourceAttributesForLevel: ( ULogMessageLevel )level
{
    NSFont            * font;
    NSColor           * color;
    
    font = [ NSFont fontWithName: [ ULogSettings sharedInstance ].fontName size: [ ULogSettings sharedInstance ].fontSize ];
    
    switch( level )
    {
        case ULogMessageLevelEmergency: color = [ ULogSettings sharedInstance ].colorTheme.emergencyColors.sourceColor; break;
        case ULogMessageLevelAlert:     color = [ ULogSettings sharedInstance ].colorTheme.alertColors.sourceColor;     break;
        case ULogMessageLevelCritical:  color = [ ULogSettings sharedInstance ].colorTheme.criticalColors.sourceColor;  break;
        case ULogMessageLevelError:     color = [ ULogSettings sharedInstance ].colorTheme.errorColors.sourceColor;     break;
        case ULogMessageLevelWarning:   color = [ ULogSettings sharedInstance ].colorTheme.warningColors.sourceColor;   break;
        case ULogMessageLevelNotice:    color = [ ULogSettings sharedInstance ].colorTheme.noticeColors.sourceColor;    break;
        case ULogMessageLevelInfo:      color = [ ULogSettings sharedInstance ].colorTheme.infoColors.sourceColor;      break;
        case ULogMessageLevelDebug:     color = [ ULogSettings sharedInstance ].colorTheme.debugColors.sourceColor;     break;
        default:                        color = nil;                                                                    break;
    }
    
    if( color )
    {
        return @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    }
    
    return @{ NSFontAttributeName : font };
}

- ( NSDictionary * )levelAttributesForLevel: ( ULogMessageLevel )level
{
    NSFont            * font;
    NSColor           * color;
    
    font = [ NSFont fontWithName: [ ULogSettings sharedInstance ].fontName size: [ ULogSettings sharedInstance ].fontSize ];
    
    switch( level )
    {
        case ULogMessageLevelEmergency: color = [ ULogSettings sharedInstance ].colorTheme.emergencyColors.levelColor; break;
        case ULogMessageLevelAlert:     color = [ ULogSettings sharedInstance ].colorTheme.alertColors.levelColor;     break;
        case ULogMessageLevelCritical:  color = [ ULogSettings sharedInstance ].colorTheme.criticalColors.levelColor;  break;
        case ULogMessageLevelError:     color = [ ULogSettings sharedInstance ].colorTheme.errorColors.levelColor;     break;
        case ULogMessageLevelWarning:   color = [ ULogSettings sharedInstance ].colorTheme.warningColors.levelColor;   break;
        case ULogMessageLevelNotice:    color = [ ULogSettings sharedInstance ].colorTheme.noticeColors.levelColor;    break;
        case ULogMessageLevelInfo:      color = [ ULogSettings sharedInstance ].colorTheme.infoColors.levelColor;      break;
        case ULogMessageLevelDebug:     color = [ ULogSettings sharedInstance ].colorTheme.debugColors.levelColor;     break;
        default:                        color = nil;                                                                   break;
    }
    
    if( color )
    {
        return @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    }
    
    return @{ NSFontAttributeName : font };
}

- ( NSDictionary * )messageAttributesForLevel: ( ULogMessageLevel )level
{
    NSFont            * font;
    NSColor           * color;
    
    font = [ NSFont fontWithName: [ ULogSettings sharedInstance ].fontName size: [ ULogSettings sharedInstance ].fontSize ];
    
    switch( level )
    {
        case ULogMessageLevelEmergency: color = [ ULogSettings sharedInstance ].colorTheme.emergencyColors.messageColor; break;
        case ULogMessageLevelAlert:     color = [ ULogSettings sharedInstance ].colorTheme.alertColors.messageColor;     break;
        case ULogMessageLevelCritical:  color = [ ULogSettings sharedInstance ].colorTheme.criticalColors.messageColor;  break;
        case ULogMessageLevelError:     color = [ ULogSettings sharedInstance ].colorTheme.errorColors.messageColor;     break;
        case ULogMessageLevelWarning:   color = [ ULogSettings sharedInstance ].colorTheme.warningColors.messageColor;   break;
        case ULogMessageLevelNotice:    color = [ ULogSettings sharedInstance ].colorTheme.noticeColors.messageColor;    break;
        case ULogMessageLevelInfo:      color = [ ULogSettings sharedInstance ].colorTheme.infoColors.messageColor;      break;
        case ULogMessageLevelDebug:     color = [ ULogSettings sharedInstance ].colorTheme.debugColors.messageColor;     break;
        default:                        color = nil;                                                                     break;
    }
    
    if( color )
    {
        return @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    }
    
    return @{ NSFontAttributeName : font };
}

@end

#endif
