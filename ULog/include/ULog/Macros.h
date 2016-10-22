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

#if defined( ULOG_DISABLE ) && ULOG_DISABLE == 1

#define ULog( ... )             
#define ULogEmergency( ... )    
#define ULogAlert( ... )        
#define ULogCritical( ... )     
#define ULogError( ... )        
#define ULogWarning( ... )      
#define ULogNotice( ... )       
#define ULogInfo( ... )         
#define ULogDebug( ... )        

#elif defined( __cplusplus ) && defined( __OBJC__ )

#define ULog( ... )             [ [ ULogLogger sharedInstance ] logWithSource: ULogMessageSourceOBJCXX level: ULogMessageLevelDebug format: __VA_ARGS__ ]
#define ULogEmergency( ... )    [ [ ULogLogger sharedInstance ] emergencyWithSource: ULogMessageSourceOBJCXX format: __VA_ARGS__ ]
#define ULogAlert( ... )        [ [ ULogLogger sharedInstance ] alertWithSource: ULogMessageSourceOBJCXX format: __VA_ARGS__ ]
#define ULogCritical( ... )     [ [ ULogLogger sharedInstance ] criticalWithSource: ULogMessageSourceOBJCXX format: __VA_ARGS__ ]
#define ULogError( ... )        [ [ ULogLogger sharedInstance ] errorWithSource: ULogMessageSourceOBJCXX format: __VA_ARGS__ ]
#define ULogWarning( ... )      [ [ ULogLogger sharedInstance ] warningWithSource: ULogMessageSourceOBJCXX format: __VA_ARGS__ ]
#define ULogNotice( ... )       [ [ ULogLogger sharedInstance ] noticeWithSource: ULogMessageSourceOBJCXX format: __VA_ARGS__ ]
#define ULogInfo( ... )         [ [ ULogLogger sharedInstance ] infoWithSource: ULogMessageSourceOBJCXX format: __VA_ARGS__ ]
#define ULogDebug( ... )        [ [ ULogLogger sharedInstance ] debugWithSource: ULogMessageSourceOBJCXX format: __VA_ARGS__ ]

#elif defined( __cplusplus )

#define ULog( ... )             ULog::Logger::SharedInstance()->Log( ULog::Message::SourceCXX, ULog::Message::LevelDebug, __VA_ARGS__ )
#define ULogEmergency( ... )    ULog::Logger::SharedInstance()->Emergency( ULog::Message::SourceCXX, __VA_ARGS__ )
#define ULogAlert( ... )        ULog::Logger::SharedInstance()->Alert( ULog::Message::SourceCXX, __VA_ARGS__ )
#define ULogCritical( ... )     ULog::Logger::SharedInstance()->Critical( ULog::Message::SourceCXX, __VA_ARGS__ )
#define ULogError( ... )        ULog::Logger::SharedInstance()->Error( ULog::Message::SourceCXX, __VA_ARGS__ )
#define ULogWarning( ... )      ULog::Logger::SharedInstance()->Warning( ULog::Message::SourceCXX, __VA_ARGS__ )
#define ULogNotice( ... )       ULog::Logger::SharedInstance()->Notice( ULog::Message::SourceCXX, __VA_ARGS__ )
#define ULogInfo( ... )         ULog::Logger::SharedInstance()->Info( ULog::Message::SourceCXX, __VA_ARGS__ )
#define ULogDebug( ... )        ULog::Logger::SharedInstance()->Debug( ULog::Message::SourceCXX, __VA_ARGS__ )      

#elif defined( __OBJC__ )

#define ULog( ... )             [ [ ULogLogger sharedInstance ] logWithSource: ULogMessageSourceOBJC level: ULogMessageLevelDebug format: __VA_ARGS__ ]
#define ULogEmergency( ... )    [ [ ULogLogger sharedInstance ] emergencyWithSource: ULogMessageSourceOBJC format: __VA_ARGS__ ]
#define ULogAlert( ... )        [ [ ULogLogger sharedInstance ] alertWithSource: ULogMessageSourceOBJC format: __VA_ARGS__ ]
#define ULogCritical( ... )     [ [ ULogLogger sharedInstance ] criticalWithSource: ULogMessageSourceOBJC format: __VA_ARGS__ ]
#define ULogError( ... )        [ [ ULogLogger sharedInstance ] errorWithSource: ULogMessageSourceOBJC format: __VA_ARGS__ ]
#define ULogWarning( ... )      [ [ ULogLogger sharedInstance ] warningWithSource: ULogMessageSourceOBJC format: __VA_ARGS__ ]
#define ULogNotice( ... )       [ [ ULogLogger sharedInstance ] noticeWithSource: ULogMessageSourceOBJC format: __VA_ARGS__ ]
#define ULogInfo( ... )         [ [ ULogLogger sharedInstance ] infoWithSource: ULogMessageSourceOBJC format: __VA_ARGS__ ]
#define ULogDebug( ... )        [ [ ULogLogger sharedInstance ] debugWithSource: ULogMessageSourceOBJC format: __VA_ARGS__ ]

#else

#define ULog( ... )             ULog_LogWithLevel( ULog_Message_LevelDebug, __VA_ARGS__ )
#define ULogEmergency( ... )    ULog_Emergency( __VA_ARGS__ )
#define ULogAlert( ... )        ULog_Alert( __VA_ARGS__ )
#define ULogCritical( ... )     ULog_Critical( __VA_ARGS__ )
#define ULogError( ... )        ULog_Error( __VA_ARGS__ )
#define ULogWarning( ... )      ULog_Warning( __VA_ARGS__ )
#define ULogNotice( ... )       ULog_Notice( __VA_ARGS__ )
#define ULogInfo( ... )         ULog_Info( __VA_ARGS__ )
#define ULogDebug( ... )        ULog_Debug( __VA_ARGS__ )

#endif

#endif /* ULOG_MACROS_H */
