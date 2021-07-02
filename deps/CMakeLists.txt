if (MSVC)
	set(DEPENDENCY_DLLS
		"${CMAKE_SOURCE_DIR}/deps/fmod/fmod64.dll")

	foreach (dll ${DEPENDENCY_DLLS})
		get_filename_component(dll_fn ${dll} NAME)
		configure_file(${dll} dll/${dll_fn} COPYONLY)
	endforeach ()
endif ()

add_executable(autools_dependencies IMPORTED GLOBAL)
set_target_properties(autools_dependencies PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/DO_NOT_USE)
