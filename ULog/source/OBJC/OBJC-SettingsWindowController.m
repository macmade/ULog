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
 * @file        OBJC-SettingsWindowController.m
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>

#if !defined( TARGET_OS_IOS ) || TARGET_OS_IOS == 0

@interface ULogSettingsWindowController() < NSTableViewDelegate, NSTableViewDataSource >

@property( atomic, readwrite, strong ) NSFont   * font;
@property( atomic, readwrite, strong ) NSArray  * colors;
@property( atomic, readwrite, assign ) NSInteger  selectedTheme;
@property( atomic, readwrite, strong ) NSString * fontDescription;

@property( atomic, readwrite, strong ) IBOutlet NSTableView * tableView;

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
