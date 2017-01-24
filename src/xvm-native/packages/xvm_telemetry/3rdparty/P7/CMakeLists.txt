project(P7)
cmake_minimum_required(VERSION 3.0)

option(P7_BUILD_SHARED "build shared version" ON)

set(SOURCES "Sources/ClBaical.cpp"
            "Sources/ClFile.cpp"
            "Sources/ClText.cpp"
            "Sources/Client.cpp"
            "Sources/ClNull.cpp"
            "Sources/CRC32.cpp"
            "Sources/Proxy.cpp"
            "Sources/Telemetry.cpp"
            "Sources/Trace.cpp")

if(WIN32)
  set(RESOURCES "Sources/P7Client.rc")
else()
  set(RESOURCES "")
endif()

if(P7_BUILD_SHARED)
  set(P7_BUILD_TYPE SHARED)
else()
  set(P7_BUILD_TYPE STATIC)
endif()

add_library(P7 ${P7_BUILD_TYPE} "${SOURCES}" "${RESOURCES}")
target_include_directories(P7 PRIVATE "Headers/")
target_include_directories(P7 PRIVATE "Shared/")
if(WIN32)
  target_include_directories(P7 PRIVATE "Shared/Platforms/Windows_x86/")
else()
  target_include_directories(P7 PRIVATE "Shared/Platforms/Linux_x86/")
endif()

target_link_libraries(P7 "ws2_32")

if(WIN32)
  set_target_properties(P7 PROPERTIES PREFIX "")
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)   
    set_target_properties(P7 PROPERTIES DEBUG_POSTFIX "x64d")
    set_target_properties(P7 PROPERTIES RELEASE_POSTFIX "x64")
    set_target_properties(P7 PROPERTIES RELWITHDEBINFO_POSTFIX "x64")
  else()
    set_target_properties(P7 PROPERTIES DEBUG_POSTFIX "x32d")
    set_target_properties(P7 PROPERTIES RELEASE_POSTFIX "x32")
    set_target_properties(P7 PROPERTIES RELWITHDEBINFO_POSTFIX "x32")
  endif()
else()
  set_target_properties(P7 PROPERTIES PREFIX "lib")
  set_target_properties(P7 PROPERTIES POSTFIX "")
  set_target_properties(P7 PROPERTIES DEBUG_POSTFIX "d")
endif()

install(TARGETS P7
        RUNTIME DESTINATION "." COMPONENT Runtime
        LIBRARY DESTINATION "." COMPONENT Runtime)