#include <iostream>

#include "src/fortran/subroutines.h"
#include "src/Cpp/utils.h"

int main(void)
{
	cv::Mat img = cv::imread("lena.png");
	int H = img.rows;
	int W = img.cols;
	int c = img.channels();
	std::cout << "W : " << W << " H : " << H << " W*H : " << W*H << std::endl;

	// Because fortran doesn't support uchar, we'll work in float.
	cv::Mat imgFloat;
	img.convertTo(imgFloat, CV_32FC3);

	float* dataIMG = (float*)imgFloat.data;

	float grayscale[W*H];
	s_grayscale_(dataIMG, &W, &H, &c, grayscale);

	float stretch[W*H];
	img_stretch_intensity_(grayscale, &W, &H, stretch);

	float filter[W*H];
	int TX = 5;
	int TY = 5;
	int method = 2;
	filter2d_(grayscale, &W, &H, &TX, &TY, &method, filter);

	ImgManager manager(W, H);
	manager.show(grayscale, "grayscale");
	manager.show(stretch, "stretch");
	manager.show(filter, "filter 2d");

	cv::imshow("picture", img);

	cv::waitKey(0);
    return 0;
}