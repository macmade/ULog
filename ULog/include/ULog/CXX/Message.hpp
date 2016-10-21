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
 * @header      Message.hpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#ifndef ULOG_CXX_MESSAGE_H
#define ULOG_CXX_MESSAGE_H

#include <ULog/Base.h>
#include <string>
#include <iostream>
#include <cstdarg>

namespace ULog
{
    class ULOG_EXPORT Message
    {
        public:
            
            typedef enum
            {
                SourceC         = 0,
                SourceCXX       = 1,
                SourceOBJC      = 2,
                SourceOBJCXX    = 3,
                SourceASL       = 4
            }
            Source;
            
            typedef enum
            {
                LevelEmergency  = 0,
                LevelAlert      = 1,
                LevelCritical   = 2,
                LevelError      = 3,
                LevelWarning    = 4,
                LevelNotice     = 5,
                LevelInfo       = 6,
                LevelDebug      = 7
            }
            Level;
            
            Message( Source = SourceCXX, Level level = LevelDebug, const std::string & message = "" );
            Message( Source source, Level level, const char * fmt, ... );
            Message( Source source, Level level, const char * fmt, va_list ap );
            Message( const Message & o );
            Message( Message && o );
            
            ~Message( void );
            
            Message & operator =( Message o );
            
            bool operator ==( const Message & o );
            bool operator !=( const Message & o );
            
            friend void swap( Message & o1, Message & o2 );
            friend std::ostream & operator <<( std::ostream & os, const Message & e );
            
            Source      GetSource( void )       const;
            Level       GetLevel( void )        const;
            std::string GetSourceString( void ) const;
            std::string GetLevelString( void )  const;
            std::string GetMessage( void )      const;
            std::string GetDescription( void )  const;
            
        private:
            
            class IMPL;
            
            IMPL * impl;
    };
}

#endif /* ULOG_CXX_MESSAGE_H */
