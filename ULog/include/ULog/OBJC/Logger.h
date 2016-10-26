/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2016 Jean-David Gadina - www-xs-labs.com
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
 * @header      Logger.h
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#ifndef ULOG_OBJC_LOGGER_H
#define ULOG_OBJC_LOGGER_H

#if defined( __has_feature ) && __has_feature( objc_modules )
@import Foundation;
#else
#import <Foundation/Foundation.h>
#endif

#include <ULog/Base.h>

typedef enum
{
    ULogLoggerDisplayOptionProcess  = 1 << 1,
    ULogLoggerDisplayOptionTime     = 1 << 2,
    ULogLoggerDisplayOptionSource   = 1 << 3,
    ULogLoggerDisplayOptionLevel    = 1 << 4
}
ULog_Logger_DisplayOption;

@interface ULogLogger: NSObject

@property( atomic, readwrite, assign, getter = isEnabled ) BOOL                       enabled;
@property( atomic, readwrite, assign                     ) uint64_t                   displayOptions;
@property( atomic, readonly                              ) NSArray< ULogMessage * > * messages;

+ ( instancetype )sharedInstance;

- ( void )clear;
- ( void )addLogFile: ( NSString * )path;
- ( void )addASLSender: ( NSString * )sender;

- ( void )log: ( ULogMessage * )msg;
- ( void )logWithFormat: ( NSString * )fmt, ...                                                                                             NS_FORMAT_FUNCTION( 1, 2 );
- ( void )logWithFormat: ( NSString * )fmt arguments: ( va_list )ap                                                                         NS_FORMAT_FUNCTION( 1, 0 );
- ( void )logWithLevel: ( ULogMessageLevel )level format: ( NSString * )fmt, ...                                                            NS_FORMAT_FUNCTION( 2, 3 );
- ( void )logWithLevel: ( ULogMessageLevel )level format: ( NSString * )fmt arguments: ( va_list )ap                                        NS_FORMAT_FUNCTION( 2, 0 );
- ( void )logWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level format: ( NSString * )fmt, ...                        NS_FORMAT_FUNCTION( 3, 4 );
- ( void )logWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level format: ( NSString * )fmt arguments: ( va_list )ap    NS_FORMAT_FUNCTION( 3, 0 );

- ( void )emergency: ( NSString * )fmt, ...                                                                     NS_FORMAT_FUNCTION( 1, 2 );
- ( void )emergency: ( NSString * )fmt arguments: ( va_list )ap                                                 NS_FORMAT_FUNCTION( 1, 0 );
- ( void )emergencyWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...                       NS_FORMAT_FUNCTION( 2, 3 );
- ( void )emergencyWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap   NS_FORMAT_FUNCTION( 2, 0 );

- ( void )alert: ( NSString * )fmt, ...                                                                         NS_FORMAT_FUNCTION( 1, 2 );
- ( void )alert: ( NSString * )fmt arguments: ( va_list )ap                                                     NS_FORMAT_FUNCTION( 1, 0 );
- ( void )alertWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...                           NS_FORMAT_FUNCTION( 2, 3 );
- ( void )alertWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap       NS_FORMAT_FUNCTION( 2, 0 );

- ( void )critical: ( NSString * )fmt, ...                                                                      NS_FORMAT_FUNCTION( 1, 2 );
- ( void )critical: ( NSString * )fmt arguments: ( va_list )ap                                                  NS_FORMAT_FUNCTION( 1, 0 );
- ( void )criticalWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...                        NS_FORMAT_FUNCTION( 2, 3 );
- ( void )criticalWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap    NS_FORMAT_FUNCTION( 2, 0 );

- ( void )error: ( NSString * )fmt, ...                                                                     NS_FORMAT_FUNCTION( 1, 2 );
- ( void )error: ( NSString * )fmt arguments: ( va_list )ap                                                 NS_FORMAT_FUNCTION( 1, 0 );
- ( void )errorWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...                       NS_FORMAT_FUNCTION( 2, 3 );
- ( void )errorWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap   NS_FORMAT_FUNCTION( 2, 0 );

- ( void )warning: ( NSString * )fmt, ...                                                                   NS_FORMAT_FUNCTION( 1, 2 );
- ( void )warning: ( NSString * )fmt arguments: ( va_list )ap                                               NS_FORMAT_FUNCTION( 1, 0 );
- ( void )warningWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...                     NS_FORMAT_FUNCTION( 2, 3 );
- ( void )warningWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap NS_FORMAT_FUNCTION( 2, 0 );

- ( void )notice: ( NSString * )fmt, ...                                                                    NS_FORMAT_FUNCTION( 1, 2 );
- ( void )notice: ( NSString * )fmt arguments: ( va_list )ap                                                NS_FORMAT_FUNCTION( 1, 0 );
- ( void )noticeWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...                      NS_FORMAT_FUNCTION( 2, 3 );
- ( void )noticeWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap  NS_FORMAT_FUNCTION( 2, 0 );

- ( void )info: ( NSString * )fmt, ...                                                                      NS_FORMAT_FUNCTION( 1, 2 );
- ( void )info: ( NSString * )fmt arguments: ( va_list )ap                                                  NS_FORMAT_FUNCTION( 1, 0 );
- ( void )infoWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...                        NS_FORMAT_FUNCTION( 2, 3 );
- ( void )infoWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap    NS_FORMAT_FUNCTION( 2, 0 );

- ( void )debug: ( NSString * )fmt, ...                                                                     NS_FORMAT_FUNCTION( 1, 2 );
- ( void )debug: ( NSString * )fmt arguments: ( va_list )ap                                                 NS_FORMAT_FUNCTION( 1, 0 );
- ( void )debugWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...                       NS_FORMAT_FUNCTION( 2, 3 );
- ( void )debugWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap   NS_FORMAT_FUNCTION( 2, 0 );

@end

#endif /* ULOG_OBJC_LOGGER_H */
