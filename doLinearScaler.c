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
#include <stdio.h>
#include <stdlib.h>

//extern "C" {
	void doLinearScaler_Row(void *pS0, void *pS1, void *pD,
		size_t dstWidth, size_t span);
//}

int
doLinearScaler(const void *pSrc, size_t srcWidth, size_t srcHeight, size_t srcStride,
	void *pDst, size_t dstWidth, size_t dstHeight, size_t dstStride)
{
	size_t ratio = srcWidth / dstWidth;
	if (ratio * dstWidth != srcWidth)
		return -1;
	size_t span = ratio / 2;

	const unsigned char *pS = (const unsigned char *)pSrc;
	unsigned char *pD = (unsigned char *)pDst;

	while (dstHeight--) {
		const unsigned char *pS0, *pS1;
		unsigned char *pDLine;
		pS0 = pS; 
		pS1 = pS + srcStride;
		pS = pS1 + srcStride;
		pDLine = pD;
		pD += dstStride;

		doLinearScaler_Row(pS0, pS1, pDLine, dstWidth, span * 4);
	}
}

int main() {
}
