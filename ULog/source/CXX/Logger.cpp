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
 * @file        Logger.cpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#include <ULog/ULog.h>
#include <ULog/CXX/SpinLock.hpp>
#include <cstdlib>

static ULog::Logger * volatile SharedLogger = nullptr;
static ULog::SpinLock          GlobalLock   = 0;

namespace ULog
{
    class Logger::IMPL
    {
        public:
            
            IMPL( void );
            IMPL( const IMPL & o );
            
            ~IMPL( void );
            
            std::vector< Message > _messages;
    };
    
    Logger * Logger::sharedInstance( void )
    {
        SpinLockLock( &GlobalLock );
        
        if( SharedLogger == nullptr )
        {
            SharedLogger = new Logger();
        }
        
        SpinLockUnlock( &GlobalLock );
        
        return SharedLogger;
    }
    
    Logger::Logger( void ): impl( new IMPL )
    {}
    
    Logger::Logger( const Logger & o ): impl( new IMPL( *( o.impl ) ) )
    {}
    
    Logger::Logger( Logger && o ): impl( o.impl )
    {
        o.impl = nullptr;
    }
    
    Logger::~Logger( void )
    {}
    
    Logger & Logger::operator =( Logger o )
    {
        swap( *( this ), o );
        
        return *( this );
    }
    
    void swap( Logger & o1, Logger & o2 )
    {
        using std::swap;
        
        swap( o1.impl, o2.impl );
    }
    
    std::vector< Message > Logger::GetMessages( void ) const
    {
        return this->impl->_messages;
    }
    
    Logger::IMPL::IMPL( void )
    {}
    
    Logger::IMPL::IMPL( const IMPL & o ):
        _messages( o._messages )
    {}
    
    Logger::IMPL::~IMPL( void )
    {}
}
