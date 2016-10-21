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
 * @file        Message.cpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#include <ULog/ULog.h>
#include <algorithm>
#include <cstdlib>
#include <iostream>

namespace ULog
{
    class Message::IMPL
    {
        public:
            
            IMPL( void );
            IMPL( Source source, Level level, const std::string & message );
            IMPL( const IMPL & o );
            
            ~IMPL( void );
            
            Source      _source;
            Level       _level;
            std::string _message;
            uint64_t    _time;
            uint64_t    _milliseconds;
            
            std::string GetStringWithFormat( const char * fmt, va_list ap );
    };
    
    Message::Message( Source source, Level level, const std::string & message ): impl( new IMPL( source, level, message ) )
    {}
    
    Message::Message( Source source, Level level, const char * fmt, ... ): impl( new IMPL )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->impl->_source  = source;
        this->impl->_level   = level;
        this->impl->_message = this->impl->GetStringWithFormat( fmt, ap );
        
        va_end( ap );
    }
    
    Message::Message( Source source, Level level, const char * fmt, va_list ap ): impl( new IMPL )
    {
        this->impl->_source  = source;
        this->impl->_level   = level;
        this->impl->_message = this->impl->GetStringWithFormat( fmt, ap );
    }
    
    Message::Message( const Message & o ): impl( new IMPL( *( o.impl ) ) )
    {}
    
    Message::Message( Message && o ): impl( o.impl )
    {
        o.impl = nullptr;
    }
    
    Message::~Message( void )
    {
        delete this->impl;
    }
    
    Message & Message::operator =( Message o )
    {
        swap( *( this ), o );
        
        return *( this );
    }
    
    bool Message::operator ==( const Message & o )
    {
        if( this->impl->_source != o.impl->_source )
        {
            return false;
        }
        
        if( this->impl->_level != o.impl->_level )
        {
            return false;
        }
        
        if( this->impl->_message != o.impl->_message )
        {
            return false;
        }
        
        return true;
    }
    
    bool Message::operator !=( const Message & o )
    {
        return !operator ==( o );
    }
    
    void swap( Message & o1, Message & o2 )
    {
        using std::swap;
        
        swap( o1.impl, o2.impl );
    }
    
    std::ostream & operator <<( std::ostream & os, const Message & e )
    {
        os << e.GetDescription();
        
        return os;
    }
    
    Message::Source Message::GetSource( void ) const
    {
        return this->impl->_source;
    }
    
    Message::Level Message::GetLevel( void ) const
    {
        return this->impl->_level;
    }
    
    std::string Message::GetSourceString( void ) const
    {
        switch( this->impl->_source )
        {
            case SourceCXX:     return "C++";
            case SourceC:       return "C";
            case SourceOBJC:    return "Objective-C";
            case SourceOBJCXX:  return "Objective-C++";
            case SourceASL:     return "ASL";
        }
        
        #if defined( _WIN32 ) && !defined( __clang__ )
        
        return "Unknown";
        
        #endif
    }
    
    std::string Message::GetLevelString( void ) const
    {
        switch( this->impl->_level )
        {
            case LevelEmergency:    return "Emergency";
            case LevelAlert:        return "Alert";
            case LevelCritical:     return "Critical";
            case LevelError:        return "Error";
            case LevelWarning:      return "Warning";
            case LevelNotice:       return "Notice";
            case LevelInfo:         return "Info";
            case LevelDebug:        return "Debug";
        }
        
        #if defined( _WIN32 ) && !defined( __clang__ )
        
        return "Unknown";
        
        #endif
    }
    
    std::string Message::GetMessage( void ) const
    {
        return this->impl->_message;
    }
    
    std::string Message::GetDescription( void ) const
    {
        std::string description;
        
        description = "[ "
                    + this->GetLevelString()
                    + " - "
                    + this->GetSourceString()
                    + " ]> "
                    + this->GetMessage();
                    
        return description;
    }
    
    uint64_t Message::GetTime( void ) const
    {
        return this->impl->_time;
    }
    
    uint64_t Message::GetMilliseconds( void ) const
    {
        return this->impl->_milliseconds;
    }
    
    Message::IMPL::IMPL( void ):
        _source( SourceCXX ),
        _level( LevelDebug ),
        _message( "" ),
        _time( 0 ),
        _milliseconds( 0 )
    {}
    
    Message::IMPL::IMPL( Source source, Level level, const std::string & message ):
        _source( source ),
        _level( level ),
        _message( message ),
        _time( 0 ),
        _milliseconds( 0 )
    {}
    
    Message::IMPL::IMPL( const IMPL & o ):
        _source( o._source ),
        _level( o._level ),
        _message( o._message ),
        _time( o._time ),
        _milliseconds( o._milliseconds )
    {}
    
    Message::IMPL::~IMPL( void )
    {}
    
    std::string Message::IMPL::GetStringWithFormat( const char * fmt, va_list ap )
    {
        va_list     ap2;
        int         length;
        char      * buf;
        std::string str;
        
        if( fmt == NULL )
        {
            return "";
        }
        
        va_copy( ap2, ap );
        
        length = vsnprintf( NULL, 0, fmt, ap );
        
        if( length <= 0 )
        {
            va_end( ap );
            
            return "";
        }
        
        buf = static_cast< char * >( calloc( static_cast< size_t >( length + 1 ), 1 ) );
        
        if( buf == nullptr )
        {
            return "";
        }
        
        vsnprintf( buf, static_cast< size_t >( length + 1 ), fmt, ap2 );
        va_end( ap2 );
        
        str = std::string( buf );
        
        free( buf );
        
        return str;
    }
}
