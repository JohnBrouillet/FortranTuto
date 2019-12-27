#ifndef UTILS
#define UTILS

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>

class ImgManager
{
    public:
        ImgManager(int W, int H);
        void show(float * data, std::string windowName = "image");

    private:
        int m_W;
        int m_H;
};


#endif

