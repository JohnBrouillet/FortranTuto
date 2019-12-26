cmake_minimum_required(VERSION 3.12)

project(fortranOCV)
find_package(OpenCV REQUIRED)
enable_language(Fortran)

file(GLOB_RECURSE SOURCES
	"src/fortran/*.f90"
    "src/Cpp/*.cpp"
	"main.cpp"	
)

set(RESOURCES
	lena.png)

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

add_executable(fortranOCV ${SOURCES})

file(COPY ${RESOURCES} DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(fortranOCV ${OpenCV_LIBS})