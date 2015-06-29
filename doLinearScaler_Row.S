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
.syntax unified
.thumb
.global doLinearScaler_Row
doLinearScaler_Row:	@ (pS0, pS1, pD, dstWidth, span)
	push		{r4}
	ldr			r4, [sp, #4]
	vldr.F64	d30,=#0x0b0a050403020100
	vldr.F64	d31,=#0x0f0e0d0c07060908
	mov			ip, #4
	.align 3
0:
	subs		r3, #2
	blt			3f

	cmp			r4, #2
	bne			1f
	vld1.32		{d0[0]}, [r0], ip
	vdup.32		d0, d0[0]
	vld1.32		{d1[0]}, [r1], ip
	vdup.32		d1, d1[0]

	vld1.32		{d4[0]}, [r0], ip
	vdup.32		d4, d4[0]
	vld1.32		{d5[0]}, [r1], ip
	vdup.32		d5, d4[0]
	b			2f
1:
	vld1.32		{d0[0]}, [r0], r4
	vld1.32		{d0[1]}, [r0], r4
	vld1.32		{d1[0]}, [r1], r4
	vld1.32		{d1[1]}, [r1], r4

	vld1.32		{d4[0]}, [r0], r4
	vld1.32		{d4[1]}, [r0], r4
	vld1.32		{d5[0]}, [r1], r4
	vld1.32		{d5[1]}, [r1], r4
2:
	vzip.8		d0, d1
	vzip.8		d4, d5
	vpaddl.u8	q1, q0
	vpaddl.u8	q3, q2
	vadd.u16	d0, d2, d3
	vadd.u16	d1, d6, d7

	vtbl.8		d3, {d0, d1}, d31
	vtbl.8		d2, {d0, d1}, d30
	vadd.u16	d4, d2, d3
	vshr.u16	d6, d4, #3

	vmovn.u16	d0, q3
	/*	d29 |1yY**|xVV**|0yY**|xUU**| */
	vst1.32		{d0[0]}, [r2]!
	b			0b
3:
	pop			{r4}
	bx			lr
