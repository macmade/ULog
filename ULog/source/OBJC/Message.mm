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
 * @file        Message.mm
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#import <ULog/ULog.h>

@interface ULogMessage()
{
    ULog::Message _cxxMessage;
}

@property( atomic, readwrite, assign ) ULog::Message     cxxMessage;
@property( atomic, readwrite, assign ) ULogMessageSource source;
@property( atomic, readwrite, assign ) ULogMessageLevel  level;
@property( atomic, readwrite, strong ) NSString        * sourceString;
@property( atomic, readwrite, strong ) NSString        * levelString;
@property( atomic, readwrite, strong ) NSString        * timeString;
@property( atomic, readwrite, strong ) NSString        * message;
@property( atomic, readwrite, assign ) uint64_t          time;
@property( atomic, readwrite, assign ) uint64_t          milliseconds;
@property( atomic, readwrite, strong ) NSDate          * date;

@end

@implementation ULogMessage

- ( instancetype )init
{
    return [ super init ];
}

- ( instancetype )initWithCXXMessage: ( const ULog::Message & )message
{
    if( ( self = [ super init ] ) )
    {
        self.cxxMessage = message;
    }
    
    return self;
}

- ( instancetype )initWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level message: ( NSString * )message
{
    ULog::Message::Source s;
    ULog::Message::Level  l;
    
    switch( source )
    {
        case ULogMessageSourceCXX:      s = ULog::Message::SourceCXX;       break;
        case ULogMessageSourceC:        s = ULog::Message::SourceC;         break;
        case ULogMessageSourceOBJC:     s = ULog::Message::SourceOBJC;      break;
        case ULogMessageSourceOBJCXX:   s = ULog::Message::SourceOBJCXX;    break;
        case ULogMessageSourceASL:      s = ULog::Message::SourceASL;       break;
        
        break;
    }
    
    switch( level )
    {
        case ULogMessageLevelEmergency: l = ULog::Message::LevelEmergency;  break;
        case ULogMessageLevelAlert:     l = ULog::Message::LevelAlert;      break;
        case ULogMessageLevelCritical:  l = ULog::Message::LevelCritical;   break;
        case ULogMessageLevelError:     l = ULog::Message::LevelError;      break;
        case ULogMessageLevelWarning:   l = ULog::Message::LevelWarning;    break;
        case ULogMessageLevelNotice:    l = ULog::Message::LevelNotice;     break;
        case ULogMessageLevelInfo:      l = ULog::Message::LevelInfo;       break;
        case ULogMessageLevelDebug:     l = ULog::Message::LevelDebug;      break;
        
        break;
    }
    
    return [ self initWithCXXMessage: ULog::Message( s, l, std::string( message.UTF8String ) ) ];
}

- ( instancetype )initWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level format: ( NSString * )format, ...
{
    va_list       ap;
    ULogMessage * message;
    
    va_start( ap, format );
    
    message = [ self initWithSource: source level: level format: format arguments: ap ];
    
    va_end( ap);
    
    return message;
}

- ( instancetype )initWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level format: ( NSString * )format arguments: ( va_list )ap
{
    return [ self initWithSource: source level: level message: [ [ NSString alloc ] initWithFormat: format arguments: ap ] ];
}

- ( instancetype )copyWithZone: ( nullable NSZone * )zone
{
    ULogMessage * message;
    
    message = [ [ ULogMessage allocWithZone: zone ] initWithCXXMessage: self.cxxMessage ];
    
    return message;
}

- ( ULog::Message )cxxMessage
{
    @synchronized( self )
    {
        return _cxxMessage;
    }
}

- ( void )setCxxMessage: ( ULog::Message )message
{
    @synchronized( self )
    {
        _cxxMessage         = message;
        self.sourceString   = [ NSString stringWithUTF8String: message.GetSourceString().c_str() ];
        self.levelString    = [ NSString stringWithUTF8String: message.GetLevelString().c_str() ];
        self.timeString     = [ NSString stringWithUTF8String: message.GetTimeString().c_str() ];
        self.message        = [ NSString stringWithUTF8String: message.GetMessage().c_str() ];
        self.time           = message.GetTime();
        self.milliseconds   = message.GetMilliseconds();
        self.date           = [ NSDate dateWithTimeIntervalSince1970: self.time ];
        
        switch( message.GetLevel() )
        {
            case ULog::Message::LevelEmergency: self.level = ULogMessageLevelEmergency; break;
            case ULog::Message::LevelAlert:     self.level = ULogMessageLevelAlert;     break;
            case ULog::Message::LevelCritical:  self.level = ULogMessageLevelCritical;  break;
            case ULog::Message::LevelError:     self.level = ULogMessageLevelError;     break;
            case ULog::Message::LevelWarning:   self.level = ULogMessageLevelWarning;   break;
            case ULog::Message::LevelNotice:    self.level = ULogMessageLevelNotice;    break;
            case ULog::Message::LevelInfo:      self.level = ULogMessageLevelInfo;      break;
            case ULog::Message::LevelDebug:     self.level = ULogMessageLevelDebug;     break;
            
            break;
        }
        
        switch( message.GetSource() )
        {
            case ULog::Message::SourceC:        self.source = ULogMessageSourceC;      break;
            case ULog::Message::SourceCXX:      self.source = ULogMessageSourceCXX;    break;
            case ULog::Message::SourceOBJC:     self.source = ULogMessageSourceOBJC;   break;
            case ULog::Message::SourceOBJCXX:   self.source = ULogMessageSourceOBJCXX; break;
            case ULog::Message::SourceASL:      self.source = ULogMessageSourceASL;    break;
            
            break;
        }
    }
}

- ( NSString * )description
{
    return [ [ super description ] stringByAppendingFormat: @" %s", self.cxxMessage.GetDescription().c_str() ];
}

- ( BOOL )isEqualToMessage: ( ULogMessage * )message
{
    if( message == NULL || [ message isKindOfClass: [ ULogMessage class ] ] == NO )
    {
        return NO;
    }
    
    return self.cxxMessage == message.cxxMessage;
}

- ( BOOL )isEqual: ( id )object
{
    if( object == self )
    {
        return YES;
    }
    
    if( [ object isKindOfClass: [ ULogMessage class ] ] == NO )
    {
        return NO;
    }
    
    return [ self isEqualToMessage: ( ULogMessage * )object ];
}

- ( BOOL )isEqualTo: ( id )object
{
    return [ self isEqual: object ];
}

- ( NSUInteger )hash
{
    return [ NSString stringWithUTF8String: self.cxxMessage.GetDescription().c_str() ].hash;
}

@end

