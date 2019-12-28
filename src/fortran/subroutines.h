#ifndef SUBROUTINES
#define SUBROUTINES

extern "C"
{
	extern void s_grayscale_(float* data, int* W, int* H, int* channel, float* output);
	extern void img_stretch_intensity_(float* data, int* W, int* H, float* output);
	extern void filter2d_(float* data, int* W, int* H, int* TX, int* TY, int* method, float* output);
}

#endif