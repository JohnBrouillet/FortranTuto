#include <iostream>

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>

#include "src/fortran/subroutines.h"

int main(void)
{
	cv::Mat img = cv::imread("lena.png");
	int H = img.rows;
	int W = img.cols;
	int c = img.channels();

	cv::Mat imgFloat;
	img.convertTo(imgFloat, CV_32FC3);

	float* dataIMG = (float*)imgFloat.data;

	float newDataSubRoutine[W*H] = {0.0};
	s_grayscale_(dataIMG, &W, &H, &c, newDataSubRoutine);
	cv::Mat graySubroutine(H, W, CV_32FC1, newDataSubRoutine);
	graySubroutine.convertTo(graySubroutine, CV_8UC1);

	cv::imshow("graySubroutine", graySubroutine);
	cv::imshow("fen", img);

	cv::waitKey(0);
    return 0;
}