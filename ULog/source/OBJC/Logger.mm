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

static void init( void ) __attribute__( ( constructor ) );
static void init( void )
{
    [ [ ULogLogger sharedInstance ] logWithFormat: @"Test: %i", 42 ];
}

@interface ULogLogger()

@property( atomic, readwrite, assign ) ULog::Logger * cxxLogger;

- ( instancetype )initWithCXXLogger: (  ULog::Logger * )logger NS_DESIGNATED_INITIALIZER;

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
            instance = [ [ self alloc ] initWithCXXLogger: ULog::Logger::sharedInstance() ];
        }
    );
    
    return instance;
}

- ( instancetype )init
{
    return [ self initWithCXXLogger: new ULog::Logger() ];
}

- ( instancetype )initWithCXXLogger: (  ULog::Logger * )logger
{
    if( logger == nullptr )
    {
        return nil;
    }
    
    if( ( self = [ super init ] ) )
    {
        self.cxxLogger = logger;
    }
    
    return self;
}

- ( void )dealloc
{
    if( self.cxxLogger != ULog::Logger::sharedInstance() )
    {
        delete self.cxxLogger;
    }
}

- ( BOOL )isEnabled
{
    @synchronized( self )
    {
        return self.cxxLogger->IsEnabled();
    }
}

- ( void )setEnabled: ( BOOL )value
{
    @synchronized( self )
    {
        return self.cxxLogger->SetEnabled( value );
    }
}

- ( NSArray< ULogMessage * > * )messages
{
    NSMutableArray< ULogMessage * > * array;
    std::vector< ULog::Message >      messages;
    ULogMessage                     * message;
    
    @synchronized( self )
    {
        messages = self.cxxLogger->GetMessages();
        array    = [ [ NSMutableArray alloc ] initWithCapacity: messages.size() ];
        
        for( const auto & m: messages )
        {
            message = [ [ ULogMessage alloc ] initWithCXXMessage: m ];
            
            if( message )
            {
                [ array addObject: message ];
            }
        }
        
        return [ NSArray arrayWithArray: array ];
    }
}

- ( void )log: ( ULogMessage * )msg
{
    @synchronized( self )
    {
        self.cxxLogger->Log( msg.cxxMessage );
    }
}

- ( void )logWithFormat: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self logWithFormat: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )logWithFormat: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithLevel: ULogMessageLevelDebug format: fmt arguments: ap ];
    }
}

- ( void )logWithLevel: ( ULogMessageLevel )level format: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self logWithLevel: level format: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )logWithLevel: ( ULogMessageLevel )level format: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self log: [ [ ULogMessage alloc ] initWithLevel: level format: fmt arguments: ap ] ];
    }
}

- ( void )emergency: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self emergency: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )emergency: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithLevel: ULogMessageLevelEmergency format: fmt arguments: ap ];
    }
}

- ( void )alert: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self alert: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )alert: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithLevel: ULogMessageLevelAlert format: fmt arguments: ap ];
    }
}

- ( void )critical: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self critical: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )critical: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithLevel: ULogMessageLevelCritical format: fmt arguments: ap ];
    }
}

- ( void )error: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self error: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )error: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithLevel: ULogMessageLevelError format: fmt arguments: ap ];
    }
}

- ( void )warning: ( NSString * )fmt, ...
{
    va_list ap;
    
    va_start( ap, fmt );
    
    [ self warning: fmt arguments: ap ];
    
    va_end( ap );
}

- ( void )warning: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithLevel: ULogMessageLevelWarning format: fmt arguments: ap ];
    }
}

- ( void )notice: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self notice: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )notice: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithLevel: ULogMessageLevelNotice format: fmt arguments: ap ];
    }
}

- ( void )info: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self info: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )info: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithLevel: ULogMessageLevelInfo format: fmt arguments: ap ];
    }
}

- ( void )debug: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self debug: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )debug: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithLevel: ULogMessageLevelDebug format: fmt arguments: ap ];
    }
}

@end

