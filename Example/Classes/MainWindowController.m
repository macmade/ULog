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
 * @file        MainWindowController.m
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>
#import "MainWindowController.h"
#import "CLog.h"
#import "CXXLog.hpp"
#import "OBJCLog.h"
#import "OBJCXXLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainWindowController()

@property( atomic, readwrite, strong ) NSString * buttonTitle;
@property( atomic, readwrite, assign ) BOOL       started;

- ( void )test;
- ( IBAction )startStop: ( id )sender;

@end

NS_ASSUME_NONNULL_END

@implementation MainWindowController

- ( instancetype )init
{
    return [ self initWithWindowNibName: NSStringFromClass( [ self class ] ) ];
}

- ( instancetype )initWithWindowNibName: ( NSString * )name
{
    if( ( self = [ super initWithWindowNibName: name ] ) )
    {
        self.buttonTitle = @"Start Logging...";
        
        [ NSThread detachNewThreadSelector: @selector( test ) toTarget: self withObject: nil ];
    }
    
    return self;
}

- ( IBAction )startStop: ( id )sender
{
    ( void )sender;
    
    if( self.started )
    {
        self.started     = NO;
        self.buttonTitle = @"Start Logging...";
    }
    else
    {
        self.started     = YES;
        self.buttonTitle = @"Stop Logging...";
    }
}

- ( void )test
{
    int x;
    int i;
    
    i = 0;
    x = 1;
    
    while( 1 )
    {
        if( self.started )
        {
            if( x % 4 == 0 )
            {
                OBJCXXLog( &i );
            }
            else if( x % 3 == 0 )
            {
                OBJCLog( &i );
            }
            else if( x % 2 == 0 )
            {
                CXXLog( &i );
            }
            else
            {
                CLog( &i );
            }
        }
        
        x++;
        
        [ NSThread sleepForTimeInterval: 1 ];
    }
}

@end
