cmake_minimum_required(VERSION 3.13 FATAL_ERROR)
project(autools
	VERSION 0.0.1
	DESCRIPTION "An audiometry tool for videogames"
	HOMEPAGE_URL "https://github.com/kyranet/son-audiometry-tools"
	LANGUAGES CXX)

if(MSVC)
    # CMake by default appends /W3, so we need to strip it to prevent warnings (D9025)
    string(REGEX REPLACE " /W[0-4]" "" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
    string(REGEX REPLACE " /W[0-4]" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
endif()

if(WIN32)
  # this is needed, because Windows can be weird, man.
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

option(AUTOOLS_BUILD_TESTS "Build autools tests" OFF)
option(AUTOOLS_BUILD_SAMPLES "Build autools samples" ON)

if(AUTOOLS_BUILD_SAMPLES)
  add_subdirectory(samples)
endif()

if(AUTOOLS_BUILD_TESTS)
  include(FetchContent)
  FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/release-1.10.0.zip
  )

  # For Windows: Prevent overriding the parent project's compiler/linker settings
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  FetchContent_MakeAvailable(googletest)

  enable_testing()

  add_subdirectory(tests)
endif()

add_subdirectory(src)
add_subdirectory(deps)
