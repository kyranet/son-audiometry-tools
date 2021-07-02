set(SOURCES
	"main.cpp")

add_executable(autools_simple ${SOURCES})
add_dependencies(autools_simple autools autools_dependencies)
target_link_libraries(autools_simple PRIVATE autools)

if (MSVC)
	add_custom_command(
		TARGET autools_simple POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy_directory
		$<TARGET_FILE_DIR:autools_dependencies>/dll
		$<TARGET_FILE_DIR:autools_simple>
	)
endif ()
