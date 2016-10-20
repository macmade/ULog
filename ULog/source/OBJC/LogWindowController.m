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
@property( atomic, readwrite, assign ) BOOL                 shown;

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
        self.textColor          = HEXCOLOR( 0xBFBFBF, 1 );
        self.log                = [ NSMutableAttributedString new ];
        self.lf                 = [ [ NSAttributedString alloc ] initWithString: @"\n" attributes: nil ];
        self.font               = [ NSFont fontWithName: @"Consolas" size: 10 ];
    }
    
    return self;
}

- ( void )windowDidLoad
{
    self.textAttributes                 = @{ NSForegroundColorAttributeName : self.textColor, NSFontAttributeName : self.font };
    self.window.alphaValue              = 0.95;
    self.textView.drawsBackground       = YES;
    self.textView.backgroundColor       = self.backgroundColor;
    self.textView.textContainerInset    = NSMakeSize( 5.0, 5.0 );
    self.window.title                   = [ NSString stringWithFormat: @"%@ - Logs", [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ] ];
}

- ( void )refresh
{
    NSArray< ULogMessage * >  * messages;
    ULogMessage               * message;
    NSMutableAttributedString * log;
    
    while( 1 )
    {
        messages = self.logger.messages;
        
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
        
        log = [ NSMutableAttributedString new ];
        
        for( message in messages )
        {
            [ log appendAttributedString: [ self stringForMessage: message ] ];
            
            dispatch_async
            (
                dispatch_get_main_queue(),
                ^( void )
                {
                    self.log = log;
                }
            );
        }
        
        [ NSThread sleepForTimeInterval: 0.5 ];
    }
}

- ( NSAttributedString * )stringForMessage: ( ULogMessage * )message
{
    NSAttributedString        * source;
    NSAttributedString        * level;
    NSAttributedString        * text;
    NSMutableAttributedString * str;
    
    source = [ [ NSAttributedString alloc ] initWithString: message.sourceString attributes: self.textAttributes ];
    level  = [ [ NSAttributedString alloc ] initWithString: message.levelString  attributes: self.textAttributes ];
    text   = [ [ NSAttributedString alloc ] initWithString: message.message      attributes: self.textAttributes ];
    str    = [ NSMutableAttributedString new ];
    
    [ str appendAttributedString: source ];
    [ str appendAttributedString: level ];
    [ str appendAttributedString: text ];
    [ str appendAttributedString: self.lf ];
    
    return str;
}

@end

#endif
