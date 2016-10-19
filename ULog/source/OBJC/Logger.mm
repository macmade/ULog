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
 * @file        Logger.mm
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#include <ULog/ULog.h>

@interface ULogLogger()

@property( atomic, readwrite, assign ) ULog::Logger * logger;

- ( instancetype )initWithLogger: (  ULog::Logger * )logger NS_DESIGNATED_INITIALIZER;

@end

@implementation ULogLogger

+ ( instancetype )sharedInstance
{
    static dispatch_once_t once;
    static id              instance = nil;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            instance = [ [ self alloc ] initWithLogger: ULog::Logger::sharedInstance() ];
        }
    );
    
    return instance;
}

- ( instancetype )init
{
    return [ self initWithLogger: new ULog::Logger() ];
}

- ( instancetype )initWithLogger: (  ULog::Logger * )logger
{
    if( ( self = [ super init ] ) )
    {
        self.logger = logger;
    }
    
    return self;
}

- ( void )dealloc
{
    if( self.logger != ULog::Logger::sharedInstance() )
    {
        delete self.logger;
    }
}

@end

