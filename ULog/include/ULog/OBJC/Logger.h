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

@interface ULogLogger: NSObject

@property( atomic, readwrite, assign, getter = isEnabled ) BOOL                       enabled;
@property( atomic, readonly                              ) NSArray< ULogMessage * > * messages;

+ ( instancetype )sharedInstance;

- ( void )log: ( ULogMessage * )msg;
- ( void )logWithFormat: ( NSString * )fmt, ...;
- ( void )logWithFormat: ( NSString * )fmt arguments: ( va_list )ap;
- ( void )logWithLevel: ( ULogMessageLevel )level format: ( NSString * )fmt, ...;
- ( void )logWithLevel: ( ULogMessageLevel )level format: ( NSString * )fmt arguments: ( va_list )ap;
- ( void )logWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level format: ( NSString * )fmt, ...;
- ( void )logWithSource: ( ULogMessageSource )source level: ( ULogMessageLevel )level format: ( NSString * )fmt arguments: ( va_list )ap;

- ( void )emergency: ( NSString * )fmt, ...;
- ( void )emergency: ( NSString * )fmt arguments: ( va_list )ap;
- ( void )emergencyWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...;
- ( void )emergencyWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap;

- ( void )alert: ( NSString * )fmt, ...;
- ( void )alert: ( NSString * )fmt arguments: ( va_list )ap;
- ( void )alertWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...;
- ( void )alertWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap;

- ( void )critical: ( NSString * )fmt, ...;
- ( void )critical: ( NSString * )fmt arguments: ( va_list )ap;
- ( void )criticalWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...;
- ( void )criticalWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap;

- ( void )error: ( NSString * )fmt, ...;
- ( void )error: ( NSString * )fmt arguments: ( va_list )ap;
- ( void )errorWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...;
- ( void )errorWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap;

- ( void )warning: ( NSString * )fmt, ...;
- ( void )warning: ( NSString * )fmt arguments: ( va_list )ap;
- ( void )warningWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...;
- ( void )warningWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap;

- ( void )notice: ( NSString * )fmt, ...;
- ( void )notice: ( NSString * )fmt arguments: ( va_list )ap;
- ( void )noticeWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...;
- ( void )noticeWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap;

- ( void )info: ( NSString * )fmt, ...;
- ( void )info: ( NSString * )fmt arguments: ( va_list )ap;
- ( void )infoWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...;
- ( void )infoWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap;

- ( void )debug: ( NSString * )fmt, ...;
- ( void )debug: ( NSString * )fmt arguments: ( va_list )ap;
- ( void )debugWithSource: ( ULogMessageSource )source format: ( NSString * )fmt, ...;
- ( void )debugWithSource: ( ULogMessageSource )source format: ( NSString * )fmt arguments: ( va_list )ap;

@end

#endif /* ULOG_OBJC_LOGGER_H */
