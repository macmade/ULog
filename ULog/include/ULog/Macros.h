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
 * @header      Macros.h
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#ifndef ULOG_MACROS_H
#define ULOG_MACROS_H

#if defined( __cplusplus ) && defined( __OBJC__ )

#define ULog( _fmt_, ... )              [ [ ULogLogger sharedInstance ] logWithSource: ULogMessageSourceOBJCXX level: ULogMessageLevelDebug format: _fmt_, __VA_ARGS__ ]
#define ULogEmergency( _fmt_, ... )     [ [ ULogLogger sharedInstance ] emergencyWithSource: ULogMessageSourceOBJCXX format: _fmt_, __VA_ARGS__ ]
#define ULogAlert( _fmt_, ... )         [ [ ULogLogger sharedInstance ] alertWithSource: ULogMessageSourceOBJCXX format: _fmt_, __VA_ARGS__ ]
#define ULogCritical( _fmt_, ... )      [ [ ULogLogger sharedInstance ] criticalWithSource: ULogMessageSourceOBJCXX format: _fmt_, __VA_ARGS__ ]
#define ULogError( _fmt_, ... )         [ [ ULogLogger sharedInstance ] errorWithSource: ULogMessageSourceOBJCXX format: _fmt_, __VA_ARGS__ ]
#define ULogWarning( _fmt_, ... )       [ [ ULogLogger sharedInstance ] warningWithSource: ULogMessageSourceOBJCXX format: _fmt_, __VA_ARGS__ ]
#define ULogNotice( _fmt_, ... )        [ [ ULogLogger sharedInstance ] noticeWithSource: ULogMessageSourceOBJCXX format: _fmt_, __VA_ARGS__ ]
#define ULogInfo( _fmt_, ... )          [ [ ULogLogger sharedInstance ] infoWithSource: ULogMessageSourceOBJCXX format: _fmt_, __VA_ARGS__ ]
#define ULogDebug( _fmt_, ... )         [ [ ULogLogger sharedInstance ] debugWithSource: ULogMessageSourceOBJCXX format: _fmt_, __VA_ARGS__ ]

#elif defined( __cplusplus )

#define ULog( _fmt_, ... )              ULog::Logger::SharedInstance()->Log( ULog::Message::SourceCXX, ULog::Message::LevelDebug, _fmt_, __VA_ARGS__ )
#define ULogEmergency( _fmt_, ... )     ULog::Logger::SharedInstance()->Emergency( ULog::Message::SourceCXX, _fmt_, __VA_ARGS__ )
#define ULogAlert( _fmt_, ... )         ULog::Logger::SharedInstance()->Alert( ULog::Message::SourceCXX, _fmt_, __VA_ARGS__ )
#define ULogCritical( _fmt_, ... )      ULog::Logger::SharedInstance()->Critical( ULog::Message::SourceCXX, _fmt_, __VA_ARGS__ )
#define ULogError( _fmt_, ... )         ULog::Logger::SharedInstance()->Error( ULog::Message::SourceCXX, _fmt_, __VA_ARGS__ )
#define ULogWarning( _fmt_, ... )       ULog::Logger::SharedInstance()->Warning( ULog::Message::SourceCXX, _fmt_, __VA_ARGS__ )
#define ULogNotice( _fmt_, ... )        ULog::Logger::SharedInstance()->Notice( ULog::Message::SourceCXX, _fmt_, __VA_ARGS__ )
#define ULogInfo( _fmt_, ... )          ULog::Logger::SharedInstance()->Info( ULog::Message::SourceCXX, _fmt_, __VA_ARGS__ )
#define ULogDebug( _fmt_, ... )         ULog::Logger::SharedInstance()->Debug( ULog::Message::SourceCXX, _fmt_, __VA_ARGS__ )      

#elif defined( __OBJC__ )

#define ULog( _fmt_, ... )              [ [ ULogLogger sharedInstance ] logWithSource: ULogMessageSourceOBJC level: ULogMessageLevelDebug format: _fmt_, __VA_ARGS__ ]
#define ULogEmergency( _fmt_, ... )     [ [ ULogLogger sharedInstance ] emergencyWithSource: ULogMessageSourceOBJC format: _fmt_, __VA_ARGS__ ]
#define ULogAlert( _fmt_, ... )         [ [ ULogLogger sharedInstance ] alertWithSource: ULogMessageSourceOBJC format: _fmt_, __VA_ARGS__ ]
#define ULogCritical( _fmt_, ... )      [ [ ULogLogger sharedInstance ] criticalWithSource: ULogMessageSourceOBJC format: _fmt_, __VA_ARGS__ ]
#define ULogError( _fmt_, ... )         [ [ ULogLogger sharedInstance ] errorWithSource: ULogMessageSourceOBJC format: _fmt_, __VA_ARGS__ ]
#define ULogWarning( _fmt_, ... )       [ [ ULogLogger sharedInstance ] warningWithSource: ULogMessageSourceOBJC format: _fmt_, __VA_ARGS__ ]
#define ULogNotice( _fmt_, ... )        [ [ ULogLogger sharedInstance ] noticeWithSource: ULogMessageSourceOBJC format: _fmt_, __VA_ARGS__ ]
#define ULogInfo( _fmt_, ... )          [ [ ULogLogger sharedInstance ] infoWithSource: ULogMessageSourceOBJC format: _fmt_, __VA_ARGS__ ]
#define ULogDebug( _fmt_, ... )         [ [ ULogLogger sharedInstance ] debugWithSource: ULogMessageSourceOBJC format: _fmt_, __VA_ARGS__ ]

#else

#define ULog( _fmt_, ... )              ULog_Log( ULog_Message_LevelDebug, _fmt_, __VA_ARGS__ )
#define ULogEmergency( _fmt_, ... )     ULog_Emergency( _fmt_, __VA_ARGS__ )
#define ULogAlert( _fmt_, ... )         ULog_Alert( _fmt_, __VA_ARGS__ )
#define ULogCritical( _fmt_, ... )      ULog_Critical( _fmt_, __VA_ARGS__ )
#define ULogError( _fmt_, ... )         ULog_Error( _fmt_, __VA_ARGS__ )
#define ULogWarning( _fmt_, ... )       ULog_Warning( _fmt_, __VA_ARGS__ )
#define ULogNotice( _fmt_, ... )        ULog_Notice( _fmt_, __VA_ARGS__ )
#define ULogInfo( _fmt_, ... )          ULog_Info( _fmt_, __VA_ARGS__ )
#define ULogDebug( _fmt_, ... )         ULog_Debug( _fmt_, __VA_ARGS__ )

#endif

#endif /* ULOG_MACROS_H */
