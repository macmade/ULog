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
#include <asl.h>

namespace ULog
{
    class ASL::IMPL
    {
        public:
            
            IMPL( void );
            IMPL( const IMPL & o );
            
            ~IMPL( void );
        
        mutable std::recursive_mutex _rmtx;
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
    
    ASL::IMPL::IMPL( void )
    {}
    
    ASL::IMPL::IMPL( const IMPL & o )
    {
        std::lock_guard< std::recursive_mutex > l( o._rmtx );
    }
    
    ASL::IMPL::~IMPL( void )
    {}
}

#endif
