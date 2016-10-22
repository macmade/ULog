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
 * @file        SettingsWindowController.m
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>

#if !defined( TARGET_OS_IOS ) || TARGET_OS_IOS == 0

@interface ULogSettingsColorItem: NSObject

- ( instancetype )initWithLabel: ( NSString * )label color: ( NSColor * )color changedSelector: ( SEL )selector;
- ( instancetype )initWithLabel: ( NSString * )label color: ( NSColor * )color textColor: ( NSColor * )textColor changedSelector: ( SEL )selector;

@property( atomic, readwrite, strong ) NSString * label;
@property( atomic, readwrite, strong ) NSColor  * color;
@property( atomic, readwrite, strong ) NSColor  * textColor;
@property( atomic, readwrite, assign ) SEL        changedSelector;

@end

@implementation ULogSettingsColorItem

- ( instancetype )initWithLabel: ( NSString * )label color: ( NSColor * )color changedSelector: ( SEL )selector
{
    return [ self initWithLabel: label color: color textColor: color changedSelector: selector ];
}

- ( instancetype )initWithLabel: ( NSString * )label color: ( NSColor * )color textColor: ( NSColor * )textColor changedSelector: ( SEL )selector
{
    if( ( self = [ self init ] ) )
    {
        self.label           = label;
        self.color           = color;
        self.textColor       = textColor;
        self.changedSelector = selector;
        
        [ self addObserver: self forKeyPath: @"color" options: NSKeyValueObservingOptionNew context: NULL ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ self removeObserver: self forKeyPath: @"color" ];
}

- ( void )observeValueForKeyPath: ( NSString * )keyPath ofObject: ( id )object change: ( NSDictionary * )change context: ( void * )context
{
    ( void )context;
    ( void )change;
    
    if( object == self && [ keyPath isEqualToString: @"color" ] )
    {
        if( self.changedSelector )
        {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [ [ ULogSettings sharedInstance ] performSelector: self.changedSelector withObject: self.color ];
            #pragma clang diagnostic pop
        }
    }
}

@end

@interface ULogSettingsWindowController() < NSTableViewDelegate, NSTableViewDataSource >

@property( atomic, readwrite, strong ) NSFont   * font;
@property( atomic, readwrite, strong ) NSArray  * colors;
@property( atomic, readwrite, assign ) NSInteger  selectedTheme;
@property( atomic, readwrite, strong ) NSString * fontDescription;

@property( atomic, readwrite, strong ) IBOutlet NSArrayController * arrayController;
@property( atomic, readwrite, strong ) IBOutlet NSTableView       * tableView;

- ( IBAction )chooseFont: ( id )sender;
- ( void )changeFont: ( id )sender;
- ( void )update;
- ( IBAction )choosePreset: ( id )sender;
- ( IBAction )restoreDefaults: ( id )sender;

@end

@implementation ULogSettingsWindowController

- ( instancetype )init
{
    if( ( self = [ self initWithWindowNibName: NSStringFromClass( [ self class ] ) ] ) )
    {
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( update ) name: ULogSettingsNotificationDefaultsChanged  object: nil ];
        [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( update ) name: ULogSettingsNotificationDefaultsRestored object: nil ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

- ( void )windowDidLoad
{
    [ self update ];
}

- ( IBAction )chooseFont: ( id )sender
{
    NSFontManager * manager;
    NSFontPanel   * panel;
    NSFont        * font;
    
    font    = [ NSFont fontWithName: [ ULogSettings sharedInstance ].fontName size: [ ULogSettings sharedInstance ].fontSize ];
    manager = [ NSFontManager sharedFontManager ];
    panel   = [ manager fontPanel: YES ];
    
    [ manager setSelectedFont: font isMultiple: NO ];
    
    [ panel makeKeyAndOrderFront: sender ];
}

- ( void )changeFont: ( id )sender
{
    NSFontManager * manager;
    NSFont        * font;
    
    if( [ sender isKindOfClass: [ NSFontManager class ] ] == NO )
    {
        return;
    }
    
    manager = ( NSFontManager * )sender;
    font    = [ manager convertFont: [ manager selectedFont ] ];
    
    [ ULogSettings sharedInstance ].fontName = font.fontName;
    [ ULogSettings sharedInstance ].fontSize = font.pointSize;
    
    [ self update ];
}

- ( void )update
{
    self.fontDescription           = [ NSString stringWithFormat: @"%@ %u", [ ULogSettings sharedInstance ].fontName, ( unsigned int )( [ ULogSettings sharedInstance ].fontSize ) ];
    self.tableView.backgroundColor = [ ULogSettings sharedInstance ].backgroundColor;
    self.font                      = [ NSFont fontWithName: [ ULogSettings sharedInstance ].fontName size: [ ULogSettings sharedInstance ].fontSize ];
    self.selectedTheme             = 0;
    
    self.colors = @[
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Background" color: [ ULogSettings sharedInstance ].backgroundColor textColor: [ ULogSettings sharedInstance ].foregoundColor changedSelector: @selector( setBackgroundColor: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Foreground" color: [ ULogSettings sharedInstance ].foregoundColor changedSelector: @selector( setForegoundColor: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Time" color: [ ULogSettings sharedInstance ].timeColor changedSelector: @selector( setTimeColor: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Source" color: [ ULogSettings sharedInstance ].sourceColor changedSelector: @selector( setSourceColor: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Level" color: [ ULogSettings sharedInstance ].levelColor changedSelector: @selector( setLevelColor: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Message" color: [ ULogSettings sharedInstance ].messageColor changedSelector: @selector( setMessageColor: ) ]
    ];
}

- ( IBAction )choosePreset: ( id )sender
{
    NSColor * background;
    NSColor * foreground;
    NSColor * time;
    NSColor * source;
    NSColor * level;
    NSColor * message;
    
    ( void )sender;
    
    switch( self.selectedTheme )
    {
        /* BareBones */
        case 1:
            
            background  = ULOG_HEXCOLOR( 0xFFFFFF, 1 );
            foreground  = ULOG_HEXCOLOR( 0x7F7F7F, 1 );
            time        = ULOG_HEXCOLOR( 0x993300, 1 );
            source      = ULOG_HEXCOLOR( 0x0000CC, 1 );
            level       = ULOG_HEXCOLOR( 0xFF3399, 1 );
            message     = ULOG_HEXCOLOR( 0x000000, 1 );
            
            break;
        
        /* Dusk */
        case 2:
            
            background  = ULOG_HEXCOLOR( 0x1E2028, 1 );
            foreground  = ULOG_HEXCOLOR( 0x55747C, 1 );
            time        = ULOG_HEXCOLOR( 0x41B645, 1 );
            source      = ULOG_HEXCOLOR( 0xC67C48, 1 );
            level       = ULOG_HEXCOLOR( 0xDB2C38, 1 );
            message     = ULOG_HEXCOLOR( 0xFFFFFF, 1 );
            
            break;
            
        /* Sunset */
        case 3:
            
            background  = ULOG_HEXCOLOR( 0xFFFCE5, 1 );
            foreground  = ULOG_HEXCOLOR( 0x646485, 1 );
            time        = ULOG_HEXCOLOR( 0x4349AC, 1 );
            source      = ULOG_HEXCOLOR( 0x476A97, 1 );
            level       = ULOG_HEXCOLOR( 0xDF0700, 1 );
            message     = ULOG_HEXCOLOR( 0xC3741C, 1 );
            
            break;
            
        /* Xcode */
        case 4:
            
            background  = ULOG_HEXCOLOR( 0xFFFFFF, 1 );
            foreground  = ULOG_HEXCOLOR( 0x203C3F, 1 );
            time        = ULOG_HEXCOLOR( 0x1D8519, 1 );
            source      = ULOG_HEXCOLOR( 0x000BFF, 1 );
            level       = ULOG_HEXCOLOR( 0xBA0011, 1 );
            message     = ULOG_HEXCOLOR( 0x000000, 1 );
            
            break;
            
        /* XS - Dark */
        case 5:
            
            background  = ULOG_HEXCOLOR( 0x161A1D, 1 );
            foreground  = ULOG_HEXCOLOR( 0x6C6C6C, 1 );
            time        = ULOG_HEXCOLOR( 0x5A773C, 1 );
            source      = ULOG_HEXCOLOR( 0x5EA09F, 1 );
            level       = ULOG_HEXCOLOR( 0x996633, 1 );
            message     = ULOG_HEXCOLOR( 0xBFBFBF, 1 );
            
            break;
            
        /* XS - Light */
        case 6:
            
            background  = ULOG_HEXCOLOR( 0xFFFFFF, 1 );
            foreground  = ULOG_HEXCOLOR( 0x7F7F7F, 1 );
            time        = ULOG_HEXCOLOR( 0x7F007F, 1 );
            source      = ULOG_HEXCOLOR( 0x007FFF, 1 );
            level       = ULOG_HEXCOLOR( 0xFF7F7F, 1 );
            message     = ULOG_HEXCOLOR( 0x000000, 1 );
            
            break;
            
        default:
            
            self.selectedTheme = 0;
            
            return;
    }
    
    [ ULogSettings sharedInstance ].backgroundColor = background;
    [ ULogSettings sharedInstance ].foregoundColor  = foreground;
    [ ULogSettings sharedInstance ].timeColor       = time;
    [ ULogSettings sharedInstance ].sourceColor     = source;
    [ ULogSettings sharedInstance ].levelColor      = level;
    [ ULogSettings sharedInstance ].messageColor    = message;
    
    [ self update ];
}

- ( IBAction )restoreDefaults: ( id )sender
{
    ( void )sender;
    
    [ [ ULogSettings sharedInstance ] restoreDefaults ];
    [ self update ];
}

@end

#endif
