#ifndef SUBROUTINES
#define SUBROUTINES

extern "C"
{
	extern void s_grayscale_(float* data, int* W, int* H, int* channel, float* output);
	extern void img_stretch_intensity_(float* data, int* W, int* H, float* output);
}

#endif