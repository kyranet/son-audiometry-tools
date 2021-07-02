set(AUTOOLS_SOURCES
	"main.cpp")

add_library(autools SHARED ${AUTOOLS_SOURCES})
target_compile_features(autools PUBLIC cxx_std_17)

target_link_libraries(autools $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/deps/fmod/lib/fmod64_vc.lib>)
target_include_directories(autools
	PUBLIC
	$<BUILD_INTERFACE:${autools_SOURCE_DIR}/include>
	$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/deps/fmod/include>
	$<INSTALL_INTERFACE:include>)

if (MSVC)
	add_custom_command(
		TARGET autools POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy_directory
		$<TARGET_FILE_DIR:autools_dependencies>/dll
		$<TARGET_FILE_DIR:autools>
	)

	target_compile_options(autools
		PRIVATE
		/W4
	)
	get_target_property(opts autools COMPILE_OPTIONS)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	target_compile_options(autools
		PRIVATE
		-pedantic
		-pedantic-errors
		-Wall
		-Wextra
		-Wno-float-equal
		-Wno-padded
	)
else ()
	target_compile_options(autools
		PRIVATE
		-pedantic
		-pedantic-errors
		-Wall
		-Wextra
		-Wconversion
		-Wno-c++98-compat
		-Wno-c++98-compat-pedantic
		-Wno-float-equal
		-Wno-padded
		-Wno-reserved-id-macro
	)
endif ()
