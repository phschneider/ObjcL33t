// Copyright (c) 2011, Nason Tech.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
// 
// Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
// Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, TH
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "NTCGGeometry.h"

NTCGOffset NTCGOffsetMake(CGFloat top, CGFloat right, CGFloat bottom, CGFloat left)
{
	NTCGOffset offset;
	offset.top = top;
	offset.bottom = bottom;
	offset.right = right;
	offset.left = left;

	return offset;
}

CGFloat NTCGOffsetGetWidth(NTCGOffset offset)
{
	return offset.left + offset.right;
}

CGFloat NTCGOffsetGetHeight(NTCGOffset offset)
{
	return offset.top + offset.bottom;
}

CGPoint NTCGRectGetCenter(CGRect rect)
{
	return CGPointMake(rect.size.width / 2, rect.size.height / 2);
}