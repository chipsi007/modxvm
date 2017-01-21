project(xvm_telemetry)
cmake_minimum_required (VERSION 3.0)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/../../release/packages/xvm_telemetry/native/)
endif()

include_directories("../../libpython/release/libpython/include/python2.7")
link_directories("../../libpython/release/libpython/lib")

add_subdirectory(3rdparty/minhook)
add_subdirectory(3rdparty/P7)

#profiler
include_directories("${CMAKE_SOURCE_DIR}/3rdparty")
include_directories("${CMAKE_SOURCE_DIR}/src")

set(SOURCES_PROFILER "src/common/dllmain.c"
                     "src/common/logger.cpp"
					 "src/common/timer.cpp"

					 "src/pythonModule.cpp"

					 "src/performance/frametime/direct3Dv9.cpp"
					 "src/performance/frametime/direct3Dv11.cpp"
					 )

add_library(XVMNativeTelemetry SHARED "${SOURCES_PROFILER}")  

target_link_libraries(XVMNativeTelemetry "python27")
target_link_libraries(XVMNativeTelemetry "P7")
target_link_libraries(XVMNativeTelemetry "minhook")
target_link_libraries(XVMNativeTelemetry "d3d9")
target_link_libraries(XVMNativeTelemetry "d3d11")

if(MSVC)
    set_target_properties(XVMNativeTelemetry PROPERTIES COMPILE_FLAGS "/wd4005")
endif()

set_target_properties(XVMNativeTelemetry PROPERTIES SUFFIX ".pyd")

install(TARGETS  XVMNativeTelemetry
        RUNTIME DESTINATION "." COMPONENT Runtime
        LIBRARY DESTINATION "." COMPONENT Runtime)