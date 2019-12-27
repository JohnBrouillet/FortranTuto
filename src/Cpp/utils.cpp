#include "utils.h"

ImgManager::ImgManager(int W, int H)
{
    m_W = W;
    m_H = H;
}

void ImgManager::show(float * data, std::string windowName)
{
    cv::Mat img(m_H, m_W, CV_32FC1, data);
	img.convertTo(img, CV_8UC1);

	cv::imshow(windowName, img);
}