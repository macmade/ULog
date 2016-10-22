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

#import <ULog/ULog.h>

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
            instance = [ [ self alloc ] initWithCXXLogger: ULog::Logger::SharedInstance() ];
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
    if( self.cxxLogger != ULog::Logger::SharedInstance() )
    {
        delete self.cxxLogger;
    }
}

- ( uint64_t )displayOptions
{
    uint64_t o;
    uint64_t r;
    
    @synchronized( self )
    {
        r = 0;
        o = self.cxxLogger->GetDisplayOptions();
        
        if( o & ULog::Logger::DisplayOptionProcess )
        {
            r |= ULogLoggerDisplayOptionProcess;
        }
        
        if( o & ULog::Logger::DisplayOptionTime )
        {
            r |= ULogLoggerDisplayOptionTime;
        }
        
        if( o & ULog::Logger::DisplayOptionSource )
        {
            r |= ULogLoggerDisplayOptionSource;
        }
        
        if( o & ULog::Logger::DisplayOptionLevel )
        {
            r |= ULogLoggerDisplayOptionLevel;
        }
        
        return r;
    }
}

- ( void )setDisplayOptions: ( uint64_t )opt
{
    uint64_t o;
    
    @synchronized( self )
    {
        o = 0;
        
        if( opt & ULogLoggerDisplayOptionProcess )
        {
            o |= ULog::Logger::DisplayOptionProcess;
        }
        
        if( opt & ULogLoggerDisplayOptionTime )
        {
            o |= ULog::Logger::DisplayOptionTime;
        }
        
        if( opt & ULogLoggerDisplayOptionSource )
        {
            o |= ULog::Logger::DisplayOptionSource;
        }
        
        if( opt & ULogLoggerDisplayOptionLevel )
        {
            o |= ULog::Logger::DisplayOptionLevel;
        }
        
        self.cxxLogger->SetDisplayOptions( o );
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

- ( void )clear
{
    @synchronized( self )
    {
        self.cxxLogger->Clear();
    }
}

- ( void )addLogFile: ( NSString * )path
{
    @synchronized( self )
    {
        if( path == nil )
        {
            return;
        }
        
        self.cxxLogger->AddLogFile( path.UTF8String );
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
        [ self logWithSource: ULogMessageSourceOBJC level: level format: fmt arguments: ap ];
    }
}

- ( void )logWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level format: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self logWithSource: source level: level format: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )logWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level format: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self log: [ [ ULogMessage alloc ] initWithSource: source level: level format: fmt arguments: ap ] ];
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
        [ self emergencyWithSource: ULogMessageSourceOBJC format: fmt arguments: ap ];
    }
}

- ( void )emergencyWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self emergencyWithSource: source format: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )emergencyWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithSource: source level: ULogMessageLevelEmergency format: fmt arguments: ap ];
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
        [ self alertWithSource: ULogMessageSourceOBJC format: fmt arguments: ap ];
    }
}

- ( void )alertWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self alertWithSource: source format: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )alertWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithSource: source level: ULogMessageLevelAlert format: fmt arguments: ap ];
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
        [ self criticalWithSource: ULogMessageSourceOBJC format: fmt arguments: ap ];
    }
}

- ( void )criticalWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self criticalWithSource: source format: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )criticalWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithSource: source level: ULogMessageLevelCritical format: fmt arguments: ap ];
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
        [ self errorWithSource: ULogMessageSourceOBJC format: fmt arguments: ap ];
    }
}

- ( void )errorWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self errorWithSource: source format: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )errorWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithSource: source level: ULogMessageLevelError format: fmt arguments: ap ];
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
        [ self warningWithSource: ULogMessageSourceOBJC format: fmt arguments: ap ];
    }
}

- ( void )warningWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self warningWithSource: source format: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )warningWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithSource: source level: ULogMessageLevelWarning format: fmt arguments: ap ];
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
        [ self noticeWithSource: ULogMessageSourceOBJC format: fmt arguments: ap ];
    }
}

- ( void )noticeWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self noticeWithSource: source format: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )noticeWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithSource: source level: ULogMessageLevelNotice format: fmt arguments: ap ];
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
        [ self infoWithSource: ULogMessageSourceOBJC format: fmt arguments: ap ];
    }
}

- ( void )infoWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self infoWithSource: source format: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )infoWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithSource: source level: ULogMessageLevelInfo format: fmt arguments: ap ];
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
        [ self debugWithSource: ULogMessageSourceOBJC format: fmt arguments: ap ];
    }
}

- ( void )debugWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...
{
    va_list ap;
    
    @synchronized( self )
    {
        va_start( ap, fmt );
        
        [ self debugWithSource: source format: fmt arguments: ap ];
        
        va_end( ap );
    }
}

- ( void )debugWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap
{
    @synchronized( self )
    {
        [ self logWithSource: source level: ULogMessageLevelDebug format: fmt arguments: ap ];
    }
}

@end

