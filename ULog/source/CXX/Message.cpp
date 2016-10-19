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

namespace ULog
{
    class Message::IMPL
    {
        public:
            
            IMPL( void );
            IMPL( Level level, const std::string & message );
            IMPL( const IMPL & o );
            
            ~IMPL( void );
            
            Level       _level;
            std::string _message;
    };
    
    Message::Message( Level level, const std::string & message ): impl( new IMPL( level, message ) )
    {}
    
    Message::Message( const Message & o ): impl( new IMPL( *( o.impl ) ) )
    {}
    
    #if __cplusplus > 199711L
    
    Message::Message( Message && o ): impl( o.impl )
    {
        o.impl = nullptr;
    }
    
    #endif
    
    Message::~Message( void )
    {
        delete this->impl;
    }
    
    Message & Message::operator =( Message o )
    {
        swap( *( this ), o );
        
        return *( this );
    }
    
    void swap( Message & o1, Message & o2 )
    {
        using std::swap;
        
        swap( o1.impl, o2.impl );
    }
    
    Message::Level Message::GetLevel( void ) const
    {
        return this->impl->_level;
    }
    
    std::string Message::GetMessage( void ) const
    {
        return this->impl->_message;
    }
    
    Message::IMPL::IMPL( void ):
        _level( LevelDebug ),
        _message( "" )
    {}
    
    Message::IMPL::IMPL( Level level, const std::string & message ):
        _level( level ),
        _message( message )
    {}
    
    Message::IMPL::IMPL( const IMPL & o ):
        _level( o._level ),
        _message( o._message )
    {}
    
    Message::IMPL::~IMPL( void )
    {}
}
