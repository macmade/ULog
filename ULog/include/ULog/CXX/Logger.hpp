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
 * @header      Logger.hpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#ifndef ULOG_CXX_LOGGER_H
#define ULOG_CXX_LOGGER_H

#include <ULog/Base.h>
#include <ULog/CXX/Message.hpp>
#include <vector>
#include <cstdarg>

namespace ULog
{
    class ULOG_EXPORT Logger
    {
        public:
            
            typedef enum
            {
                DisplayOptionProcess  = 1 << 1,
                DisplayOptionTime     = 1 << 2,
                DisplayOptionSource   = 1 << 3,
                DisplayOptionLevel    = 1 << 4
            }
            DisplayOption;
            
            static Logger * SharedInstance( void );
            
            Logger( void );
            Logger( const Logger & o );
            Logger( Logger && o );
            
            ~Logger( void );
            
            Logger & operator =( Logger o );
            
            friend void swap( Logger & o1, Logger & o2 );
            
            uint64_t GetDisplayOptions( void );
            void     SetDisplayOptions( uint64_t opt );
            
            bool IsEnabled( void ) const;
            void SetEnabled( bool value );
            
            void Clear( void );
            
            void AddLogFile( const std::string & path );
            
            void Log( const Message & msg );
            void Log( const char * fmt, ... )                                                       ULOG_ATTRIBUTE_FORMAT( 2, 3 );
            void Log( const char * fmt, va_list ap )                                                ULOG_ATTRIBUTE_FORMAT( 2, 0 );
            void Log( Message::Level level, const char * fmt, ... )                                 ULOG_ATTRIBUTE_FORMAT( 3, 4 );
            void Log( Message::Level level, const char * fmt, va_list ap )                          ULOG_ATTRIBUTE_FORMAT( 3, 0 );
            void Log( Message::Source source, Message::Level level, const char * fmt, ... )         ULOG_ATTRIBUTE_FORMAT( 4, 5 );
            void Log( Message::Source source, Message::Level level, const char * fmt, va_list ap )  ULOG_ATTRIBUTE_FORMAT( 4, 0 );
            
            void Emergency( const char * fmt, ... )                                 ULOG_ATTRIBUTE_FORMAT( 2, 3 );
            void Emergency( const char * fmt, va_list ap )                          ULOG_ATTRIBUTE_FORMAT( 2, 0 );
            void Emergency( Message::Source source, const char * fmt, ... )         ULOG_ATTRIBUTE_FORMAT( 3, 4 );
            void Emergency( Message::Source source, const char * fmt, va_list ap )  ULOG_ATTRIBUTE_FORMAT( 3, 0 );
            
            void Alert( const char * fmt, ... )                                 ULOG_ATTRIBUTE_FORMAT( 2, 3 );
            void Alert( const char * fmt, va_list ap )                          ULOG_ATTRIBUTE_FORMAT( 2, 0 );
            void Alert( Message::Source source, const char * fmt, ... )         ULOG_ATTRIBUTE_FORMAT( 3, 4 );
            void Alert( Message::Source source, const char * fmt, va_list ap )  ULOG_ATTRIBUTE_FORMAT( 3, 0 );
            
            void Critical( const char * fmt, ... )                                  ULOG_ATTRIBUTE_FORMAT( 2, 3 );
            void Critical( const char * fmt, va_list ap )                           ULOG_ATTRIBUTE_FORMAT( 2, 0 );
            void Critical( Message::Source source, const char * fmt, ... )          ULOG_ATTRIBUTE_FORMAT( 3, 4 );
            void Critical( Message::Source source, const char * fmt, va_list ap )   ULOG_ATTRIBUTE_FORMAT( 3, 0 );
            
            void Error( const char * fmt, ... )                                 ULOG_ATTRIBUTE_FORMAT( 2, 3 );
            void Error( const char * fmt, va_list ap )                          ULOG_ATTRIBUTE_FORMAT( 2, 0 );
            void Error( Message::Source source, const char * fmt, ... )         ULOG_ATTRIBUTE_FORMAT( 3, 4 );
            void Error( Message::Source source, const char * fmt, va_list ap )  ULOG_ATTRIBUTE_FORMAT( 3, 0 );
            
            void Warning( const char * fmt, ... )                                   ULOG_ATTRIBUTE_FORMAT( 2, 3 );
            void Warning( const char * fmt, va_list ap )                            ULOG_ATTRIBUTE_FORMAT( 2, 0 );
            void Warning( Message::Source source, const char * fmt, ... )           ULOG_ATTRIBUTE_FORMAT( 3, 4 );
            void Warning( Message::Source source, const char * fmt, va_list ap )    ULOG_ATTRIBUTE_FORMAT( 3, 0 );
            
            void Notice( const char * fmt, ... )                                ULOG_ATTRIBUTE_FORMAT( 2, 3 );
            void Notice( const char * fmt, va_list ap )                         ULOG_ATTRIBUTE_FORMAT( 2, 0 );
            void Notice( Message::Source source, const char * fmt, ... )        ULOG_ATTRIBUTE_FORMAT( 3, 4 );
            void Notice( Message::Source source, const char * fmt, va_list ap ) ULOG_ATTRIBUTE_FORMAT( 3, 0 );
            
            void Info( const char * fmt, ... )                                  ULOG_ATTRIBUTE_FORMAT( 2, 3 );
            void Info( const char * fmt, va_list ap )                           ULOG_ATTRIBUTE_FORMAT( 2, 0 );
            void Info( Message::Source source, const char * fmt, ... )          ULOG_ATTRIBUTE_FORMAT( 3, 4 );
            void Info( Message::Source source, const char * fmt, va_list ap )   ULOG_ATTRIBUTE_FORMAT( 3, 0 );
            
            void Debug( const char * fmt, ... )                                 ULOG_ATTRIBUTE_FORMAT( 2, 3 );
            void Debug( const char * fmt, va_list ap )                          ULOG_ATTRIBUTE_FORMAT( 2, 0 );
            void Debug( Message::Source source, const char * fmt, ... )         ULOG_ATTRIBUTE_FORMAT( 3, 4 );
            void Debug( Message::Source source, const char * fmt, va_list ap )  ULOG_ATTRIBUTE_FORMAT( 3, 0 );
            
            std::vector< Message > GetMessages( void ) const;
            
        private:
            
            class IMPL;
            
            IMPL * impl;
    };
}

#endif /* ULOG_CXX_LOGGER_H */
