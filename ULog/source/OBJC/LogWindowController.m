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
@property( atomic, readwrite, strong ) NSDictionary                 * textAttributes;
@property( atomic, readwrite, strong ) NSDictionary                 * timeAttributes;
@property( atomic, readwrite, strong ) NSDictionary                 * sourceAttributes;
@property( atomic, readwrite, strong ) NSDictionary                 * levelAttributes;
@property( atomic, readwrite, strong ) NSDictionary                 * messageAttributes;
@property( atomic, readwrite, strong ) NSString                     * searchText;
@property( atomic, readwrite, strong ) NSString                     * pauseButtonTitle;
@property( atomic, readwrite, assign ) BOOL                           shown;
@property( atomic, readwrite, assign ) BOOL                           paused;
@property( atomic, readwrite, assign ) BOOL                           editable;

@property( atomic, readwrite, strong ) IBOutlet NSTextView * textView;

- ( IBAction )clear: ( id )sender;
- ( IBAction )togglePause: ( id )sender;
- ( IBAction )save: ( id )sender;
- ( IBAction )showSettings: ( id )sender;
- ( void )updateSettings;
- ( void )updateTitleWithMessageCount: ( NSUInteger )count;
- ( void )refresh;
- ( void )renderMessages: ( NSArray * )messages until: ( ULogMessage * )last;
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
    NSFont * font;
    
    @synchronized( self )
    {
        font = [ NSFont fontWithName: [ ULogSettings sharedInstance ].fontName size: [ ULogSettings sharedInstance ].fontSize ];
        
        self.textAttributes             = @{ NSForegroundColorAttributeName : [ ULogSettings sharedInstance ].foregoundColor,   NSFontAttributeName : font };
        self.timeAttributes             = @{ NSForegroundColorAttributeName : [ ULogSettings sharedInstance ].timeColor,        NSFontAttributeName : font };
        self.sourceAttributes           = @{ NSForegroundColorAttributeName : [ ULogSettings sharedInstance ].sourceColor,      NSFontAttributeName : font };
        self.levelAttributes            = @{ NSForegroundColorAttributeName : [ ULogSettings sharedInstance ].levelColor,       NSFontAttributeName : font };
        self.messageAttributes          = @{ NSForegroundColorAttributeName : [ ULogSettings sharedInstance ].messageColor,     NSFontAttributeName : font };
        self.textView.backgroundColor   = [ ULogSettings sharedInstance ].backgroundColor;
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
    NSArray< ULogMessage * >  * messages;
    
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
            self.log = log;
            
            [ self updateTitleWithMessageCount: i ];
        }
    );
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
