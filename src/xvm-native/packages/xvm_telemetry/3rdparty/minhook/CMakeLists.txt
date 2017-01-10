project(minhook)
cmake_minimum_required(VERSION 3.0)

option(MINHOOK_BUILD_SHARED "build shared version" ON)

set(SOURCES_MINHOOK "src/buffer.c"
				   	"src/hook.c"
				   	"src/trampoline.c")

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(SOURCES_HDE "src/hde/hde64.c")
else()
  set(SOURCES_HDE "src/hde/hde32.c")
endif()

if(MINHOOK_BUILD_SHARED)
  set(MINHOOK_BUILD_TYPE SHARED)
  set(RESOURCES "dll_resources/MinHook.rc"
                "dll_resources/MinHook.def")
else()
  set(MINHOOK_BUILD_TYPE STATIC)
  set(RESOURCES "")
endif()

add_library(minhook ${MINHOOK_BUILD_TYPE} "${SOURCES_MINHOOK}" "${SOURCES_HDE}" "${RESOURCES}")
target_include_directories(minhook PRIVATE "include/")
target_include_directories(minhook PRIVATE "src/")
target_include_directories(minhook PRIVATE "src/hde/")
target_compile_definitions(minhook PRIVATE STRICT)

if(WIN32)
  set_target_properties(minhook PROPERTIES PREFIX "")
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)   
    set_target_properties(minhook PROPERTIES DEBUG_POSTFIX "x64d")
    set_target_properties(minhook PROPERTIES RELEASE_POSTFIX "x64")
    set_target_properties(minhook PROPERTIES RELWITHDEBINFO_POSTFIX "x64")
  else()
    set_target_properties(minhook PROPERTIES DEBUG_POSTFIX "x32d")
    set_target_properties(minhook PROPERTIES RELEASE_POSTFIX "x32")
    set_target_properties(minhook PROPERTIES RELWITHDEBINFO_POSTFIX "x32")
  endif()
else()
  set_target_properties(minhook PROPERTIES PREFIX "lib")
  set_target_properties(minhook PROPERTIES POSTFIX "")
  set_target_properties(minhook PROPERTIES DEBUG_POSTFIX "d")
endif()

install(TARGETS minhook
        RUNTIME DESTINATION "." COMPONENT Runtime
        LIBRARY DESTINATION "." COMPONENT Runtime)