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

#ifndef ULOG_OBJC_MESSAGE_H
#define ULOG_OBJC_MESSAGE_H

#if defined( __has_feature ) && __has_feature( objc_modules )
@import Foundation;
#else
#import <Foundation/Foundation.h>
#endif

#include <ULog/Base.h>

typedef enum
{
    ULogMessageSourceCXX        = 0,
    ULogMessageSourceC          = 1,
    ULogMessageSourceOBJC       = 2,
    ULogMessageSourceOBJCXX     = 3,
    ULogMessageSourceASL        = 4
}
ULogMessageSource;

typedef enum
{
    ULogMessageLevelEmergency   = 0,
    ULogMessageLevelAlert       = 1,
    ULogMessageLevelCritical    = 2,
    ULogMessageLevelError       = 3,
    ULogMessageLevelWarning     = 4,
    ULogMessageLevelNotice      = 5,
    ULogMessageLevelInfo        = 6,
    ULogMessageLevelDebug       = 7
}
ULogMessageLevel;

@interface ULogMessage: NSObject < NSCopying >

@property( atomic, readonly ) ULogMessageSource source;
@property( atomic, readonly ) ULogMessageLevel  level;
@property( atomic, readonly ) NSString        * sourceString;
@property( atomic, readonly ) NSString        * levelString;
@property( atomic, readonly ) NSString        * message;
@property( atomic, readonly ) uint64_t          time;
@property( atomic, readonly ) uint64_t          milliseconds;
@property( atomic, readonly ) NSDate          * date;

#ifdef __cplusplus

@property( atomic, readonly ) ULog::Message cxxMessage;

- ( instancetype )initWithCXXMessage: ( const ULog::Message & )message;

#endif

- ( instancetype )initWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level message: ( NSString * )message;
- ( instancetype )initWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level format: ( NSString * )format, ...;
- ( instancetype )initWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level format: ( NSString * )format arguments: ( va_list )ap;

- ( BOOL )isEqualToMessage: ( ULogMessage * )message;

@end

#endif /* ULOG_OBJC_MESSAGE_H */
