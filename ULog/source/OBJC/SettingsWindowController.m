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

@property( atomic, readwrite, strong ) NSString          * label;
@property( atomic, readwrite, strong ) ULogMessageColors * colors;
@property( atomic, readwrite, assign ) SEL                 changedSelector;

- ( instancetype )initWithLabel: ( NSString * )label colors: ( ULogMessageColors * )colors changedSelector: ( SEL )selector;

@end

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

@interface ULogColorTableCellView: NSTableCellView

@end

@implementation ULogColorTableCellView

- ( void )drawRect: ( NSRect )rect
{
    ULogSettingsColorItem * item;
    
    item = [ self valueForKey: @"objectValue" ];
    
    [ item.colors.backgroundColor setFill ];
    
    NSRectFill( rect );
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
    self.fontDescription    = [ NSString stringWithFormat: @"%@ %u", [ ULogSettings sharedInstance ].fontName, ( unsigned int )( [ ULogSettings sharedInstance ].fontSize ) ];
    self.font               = [ NSFont fontWithName: [ ULogSettings sharedInstance ].fontName size: [ ULogSettings sharedInstance ].fontSize ];
    self.selectedTheme      = 0;
    self.colors             = @[
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Emergency" colors: [ ULogSettings sharedInstance ].colorTheme.emergencyColors changedSelector: @selector( setEmergencyColors: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Alert"     colors: [ ULogSettings sharedInstance ].colorTheme.alertColors     changedSelector: @selector( setAlertColors: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Critical"  colors: [ ULogSettings sharedInstance ].colorTheme.criticalColors  changedSelector: @selector( setCriticalColors: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Error"     colors: [ ULogSettings sharedInstance ].colorTheme.errorColors     changedSelector: @selector( setErrorColors: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Warning"   colors: [ ULogSettings sharedInstance ].colorTheme.warningColors   changedSelector: @selector( setWarningColors: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Notice"    colors: [ ULogSettings sharedInstance ].colorTheme.noticeColors    changedSelector: @selector( setNoticeColors: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Info"      colors: [ ULogSettings sharedInstance ].colorTheme.infoColors      changedSelector: @selector( setInfoColors: ) ],
        [ [ ULogSettingsColorItem alloc ] initWithLabel: @"Debug"     colors: [ ULogSettings sharedInstance ].colorTheme.debugColors     changedSelector: @selector( setDebugColors: ) ]
    ];
}

- ( IBAction )choosePreset: ( id )sender
{
    ULogColorTheme * theme;
    
    ( void )sender;
    
    switch( self.selectedTheme )
    {
        case 1:     theme = [ ULogColorTheme civicTheme ];      break;
        case 2:     theme = [ ULogColorTheme duskTheme ];       break;
        case 3:     theme = [ ULogColorTheme midnightTheme ];   break;
        case 4:     theme = [ ULogColorTheme sunsetTheme ];     break;
        case 5:     theme = [ ULogColorTheme xcodeTheme ];      break;
        case 6:     theme = [ ULogColorTheme xsTheme ];         break;
        default:    theme = nil;
    }
    
    if( theme )
    {
        [ ULogSettings sharedInstance ].colorTheme = theme;
    }
    
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
