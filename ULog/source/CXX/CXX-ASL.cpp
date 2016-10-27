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
 * @file        ASL.cpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#include <ULog/ULog.h>
#include <ULog/CXX/ASL.hpp>

#if defined( __APPLE__ )

#include <mutex>
#include <thread>
#include <chrono>
#include <asl.h>

namespace ULog
{
    class ASL::IMPL
    {
        public:
            
            IMPL( void );
            IMPL( const IMPL & o );
            
            ~IMPL( void );
            
            void GetMessages( void );
            
        mutable std::recursive_mutex                     _rmtx;
                std::function< void( const Message & ) > _callback;
                std::vector< std::string >               _senders;
                bool                                     _started;
                bool                                     _stopped;
    };
    
    ASL::ASL( void ): impl( new IMPL )
    {}
    
    ASL::ASL( const ASL & o ): impl( new IMPL( *( o.impl ) ) )
    {}
    
    ASL::ASL( ASL && o ): impl( o.impl )
    {
        o.impl = nullptr;
    }
    
    ASL::~ASL( void )
    {
        delete this->impl;
    }
    
    ASL & ASL::operator =( ASL o )
    {
        std::lock( this->impl->_rmtx, o.impl->_rmtx );
        
        std::lock_guard< std::recursive_mutex > l1( this->impl->_rmtx, std::adopt_lock );
        std::lock_guard< std::recursive_mutex > l2( o.impl->_rmtx,     std::adopt_lock );
        
        swap( *( this ), o );
        
        return *( this );
    }
    
    void swap( ASL & o1, ASL & o2 )
    {
        std::lock( o1.impl->_rmtx, o2.impl->_rmtx );
        
        std::lock_guard< std::recursive_mutex > l1( o1.impl->_rmtx, std::adopt_lock );
        std::lock_guard< std::recursive_mutex > l2( o2.impl->_rmtx, std::adopt_lock );
        
        using std::swap;
        
        swap( o1.impl, o2.impl );
    }
    
    void ASL::SetMessageCallback( std::function< void( const Message & ) > f )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->impl->_callback = f;
    }
    
    void ASL::AddSender( const std::string & sender )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        if( sender.length() )
        {
            this->impl->_senders.push_back( sender );
        }
    }
    
    void ASL::Start( void )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        if( this->impl->_started )
        {
            return;
        }
        
        this->impl->_started = true;
        
        {
            std::thread t
            (
                [ = ]()
                {
                    this->impl->GetMessages();
                }
            );
            
            t.detach();
        }
    }
    
    bool ASL::Started( void )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        return this->impl->_started;
    }
    
    ASL::IMPL::IMPL( void ):
        _callback( nullptr ),
        _started( false ),
        _stopped( false )
    {}
    
    ASL::IMPL::IMPL( const IMPL & o ):
        _started( false ),
        _stopped( false )
    {
        std::lock_guard< std::recursive_mutex > l( o._rmtx );
        
        this->_senders  = o._senders;
        this->_callback = o._callback;
    }
    
    ASL::IMPL::~IMPL( void )
    {
        {
            std::lock_guard< std::recursive_mutex > l( this->_rmtx );
            
            this->_started = false;
        }
        
        while( 1 )
        {
            {
                std::lock_guard< std::recursive_mutex > l( this->_rmtx );
                
                if( this->_stopped )
                {
                    return;
                }
            }
        }
    }
    
    #ifdef __clang__
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    #endif
    
    void ASL::IMPL::GetMessages( void )
    {
        Message     ref;
        aslclient   client;
        std::string t;
        std::string lastID;
        
        t      = std::to_string( time( NULL ) );
        client = asl_open( NULL, NULL, 0 );
        
        while( 1 )
        {
            {
                std::lock_guard< std::recursive_mutex > l( this->_rmtx );
                
                if( this->_started == false )
                {
                    this->_stopped = true;
                    
                    asl_close( client );
                    
                    return;
                }
            }
            
            {
                aslmsg       query;
                aslresponse  response;
                aslmsg       msg;
                const char * cp;
                std::string  sender;
                
                query = asl_new( ASL_TYPE_QUERY );
                
                asl_set_query( query, ASL_KEY_MSG,  NULL,      ASL_QUERY_OP_NOT_EQUAL );
                asl_set_query( query, ASL_KEY_TIME, t.c_str(), ASL_QUERY_OP_GREATER_EQUAL );
                
                if( lastID.length() )
                {
                    asl_set_query( query, ASL_KEY_MSG_ID, lastID.c_str(), ASL_QUERY_OP_GREATER_EQUAL );
                }
                
                response = asl_search( client, query );
                
                asl_free( query );
                
                msg = asl_next( response );
                
                while( msg )
                {
                    cp = asl_get( msg, ASL_KEY_MSG_ID );
                    
                    if( cp == NULL )
                    {
                        goto next;
                    }
                    
                    lastID = cp;
                    cp     = asl_get( msg, ASL_KEY_SENDER );
                    
                    if( cp == NULL )
                    {
                        goto next;
                    }
                    
                    sender = cp;
                    
                    if( std::find( this->_senders.begin(), this->_senders.end(), sender ) == this->_senders.end() )
                    {
                        goto next;
                    }
                    
                    {
                        Message m( msg );
                        
                        if( m.GetProcessID() != ref.GetProcessID() )
                        {
                            goto next;
                        }
                        
                        if( this->_callback != nullptr )
                        {
                            this->_callback( m );
                        }
                    }
                    
                    next:
                        
                        msg = asl_next( response );
                }
            }
            
            std::this_thread::sleep_for( std::chrono::milliseconds( 500 ) );
        }
    }
    
    #ifdef __clang__
    #pragma clang diagnostic pop
    #endif
}

#endif
