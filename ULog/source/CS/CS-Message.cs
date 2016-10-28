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
 * @file        CS-Message.cs
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

namespace ULog
{
    public partial class Message
    {
        public enum Source
        {
            C      = 0,
            CXX    = 1,
            OBJC   = 2,
            OBJCXX = 3,
            ASL    = 4,
            CS     = 5
        }
        
        public enum Level
        {
            Emergency = 0,
            Alert     = 1,
            Critical  = 2,
            Error     = 3,
            Warning   = 4,
            Notice    = 5,
            Info      = 6,
            Debug     = 7
        }

        Message( Source source = Source.CXX, Level level = Level.Debug, string message = "" )
        {}

        Message( Source source, Level level, string fmt, params object[] args )
        {}

        public override bool Equals( object o )
        {
            Message m;

            if( o == null )
            {
                return false;
            }
            
            m = o as Message;

            if( ( object )m == null )
            {
                return false;
            }

            return false;
        }

        public bool Equals( Message o )
        {
            if( ( object )o == null )
            {
                return false;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return ( int )( this.GetTime() ^ this.GetMilliseconds() );
        }

        public static bool operator ==( Message o1, Message o2 )
        {
            if( ReferenceEquals( o1, o2 ) )
            {
                return true;
            }
            
            if( ( ( object )o1 == null ) || ( ( object )o2 == null ) )
            {
                return false;
            }

            return false;
        }

        public static bool operator !=( Message o1, Message o2 )
        {
            return !( o1 == o2 );
        }

        public Source GetSource()
        {
            return Source.CS;
        }

        public Level GetLevel()
        {
            return Level.Debug;
        }

        public ulong GetTime()
        {
            return 0;
        }

        public ulong GetMilliseconds()
        {
            return 0;
        }

        public ulong GetProcessID()
        {
            return 0;
        }

        public ulong GetThreadID()
        {
            return 0;
        }

        public string GetSourceString()
        {
            return "";
        }

        public string GetLevelString()
        {
            return "";
        }

        public string GetTimeString()
        {
            return "";
        }

        public string GetProcessString()
        {
            return "";
        }

        public string GetMessage()
        {
            return "";
        }

        public string GetDescription()
        {
            return "";
        }
    }
}
