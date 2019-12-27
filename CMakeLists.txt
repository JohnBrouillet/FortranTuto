cmake_minimum_required(VERSION 3.12)

project(fortranTutos)
find_package(OpenCV REQUIRED)
enable_language(Fortran)

file(GLOB_RECURSE SOURCES
	"src/fortran/*.f90"
	"src/fortran/subroutines.h"
    "src/Cpp/*.cpp"
	"src/Cpp/*.h"
	"main.cpp"	
)

set(RESOURCES
	lena.png)

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -std=f2008")

if(OPENMP_FOUND)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
endif()
if(CMAKE_COMPILER_IS_GNUCXX)
	set(CMAKE_CXX_FLAGS "-O2 -march=corei7-avx -fopenmp")
endif()

if(MSVC)
	set(CMAKE_CXX_FLAGS "/O2 /arch:AVX /openmp")
endif()

add_executable(fortranTutos ${SOURCES})

file(COPY ${RESOURCES} DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(fortranTutos ${OpenCV_LIBS})