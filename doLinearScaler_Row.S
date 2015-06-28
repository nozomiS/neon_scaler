/*
 * Copyright (c) 2015, Nozomi SATO.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * * Neither the name of neon_scaler nor the names of its
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
.global doLinearScaler_Row
doLinearScaler_Row:	@ (pS0, pS1, pD, dstWidth, span)
	ldr			ip, [sp]
	vldr.F64	d30,=#0x0b0a050403020100
	vldr.F64	d31,=#0x0f0e0d0c07060908
	.align 3
0:
	subs		r3, #8
	bxeq		lr

	vld1.32		{d0},  [r0], ip
	vld1.32		{d16}, [r0], ip
	vld1.32		{d1},  [r1], ip
	vld1.32		{d17}, [r1], ip
	vzip.8		d0, d1
	vzip.8		d16, d17
	vpaddl.u8	q1, q0
	vpaddl.u8	q9, q8
	vadd.u16	d4, d2, d3
	vadd.u16	d20, d18, d19

	vld1.32		{d0},  [r0], ip
	vld1.32		{d16}, [r0], ip
	vld1.32		{d1},  [r1], ip
	vld1.32		{d17}, [r1], ip
	vzip.8		d0, d1
	vzip.8		d16, d17
	vpaddl.u8	q1, q0
	vpaddl.u8	q9, q8
	vadd.u16	d5, d2, d3
	vadd.u16	d21, d18, d19

	vtbl.8		d7,  {d4, d5},   d31
	vtbl.8		d23, {d20, d21}, d31
	vtbl.8		d6,  {d4, d5},   d30
	vtbl.8		d22, {d20, d21}, d30
	vadd.u16	d8, d6, d7
	vadd.u16	d24, d22, d23
	vshr.u16	d14, d8, #3
	vshr.u16	d15, d24, #3

	vmovn.u16	d29, q7
	vst1.32		{d29}, [r2]! 
	b			0b
