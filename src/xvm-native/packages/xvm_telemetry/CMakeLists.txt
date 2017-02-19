project(xvm_telemetry)
cmake_minimum_required (VERSION 3.0)

include(GenerateExportHeader)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/../../release/packages/xvm_telemetry/native/)
endif()

include_directories("../../../xfw/src/native/libpython/release/libpython/include/python2.7")
link_directories("../../../xfw/src/native/libpython/release/libpython/lib")

add_subdirectory(3rdparty/minhook)
add_subdirectory(3rdparty/P7)

#profiler
include_directories("${CMAKE_SOURCE_DIR}/3rdparty")
include_directories("${CMAKE_SOURCE_DIR}/src")
include_directories("${CMAKE_BINARY_DIR}")

set(SOURCES_PROFILER       "src/common/logger.cpp"
			   "src/common/timer.cpp"
                           "src/common/pythonModule.cpp")

set(SOURCES_PROFILER_D3D9  "src/d3d9/direct3Dv9.cpp"
                           "src/d3d9/pythonModule.cpp")

set(SOURCES_PROFILER_D3D11 "src/d3d11/direct3Dv11.cpp"
                           "src/d3d11/pythonModule.cpp")

add_library(XVMNativeTelemetry SHARED "${SOURCES_PROFILER}")  
generate_export_header(XVMNativeTelemetry)
set_target_properties(XVMNativeTelemetry PROPERTIES SUFFIX ".pyd")
target_link_libraries(XVMNativeTelemetry "python27")
target_link_libraries(XVMNativeTelemetry "minhook")
target_link_libraries(XVMNativeTelemetry "P7")

add_library(XVMNativeTelemetry_d3d9 SHARED "${SOURCES_PROFILER_D3D9}")  
set_target_properties(XVMNativeTelemetry_d3d9 PROPERTIES SUFFIX ".pyd")
target_link_libraries(XVMNativeTelemetry_d3d9 "XVMNativeTelemetry")
target_link_libraries(XVMNativeTelemetry_d3d9 "python27")
target_link_libraries(XVMNativeTelemetry_d3d9 "minhook")
target_link_libraries(XVMNativeTelemetry_d3d9 "d3d9")

add_library(XVMNativeTelemetry_d3d11 SHARED "${SOURCES_PROFILER_D3D11}")  
set_target_properties(XVMNativeTelemetry_d3d11 PROPERTIES SUFFIX ".pyd")
target_link_libraries(XVMNativeTelemetry_d3d11 "XVMNativeTelemetry")
target_link_libraries(XVMNativeTelemetry_d3d11 "python27")
target_link_libraries(XVMNativeTelemetry_d3d11 "minhook")
target_link_libraries(XVMNativeTelemetry_d3d11 "d3d11")

install(TARGETS  XVMNativeTelemetry
                 XVMNativeTelemetry_d3d9
                 XVMNativeTelemetry_d3d11
        RUNTIME DESTINATION "." COMPONENT Runtime
        LIBRARY DESTINATION "." COMPONENT Runtime)