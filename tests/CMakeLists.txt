include(GoogleTest)

set(SOURCES
  "main.cpp")

add_executable(autools_tests ${SOURCES})
target_link_libraries(autools_tests
  PUBLIC
    i18n
    gtest)

add_custom_command(
  TARGET autools_tests POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory
    $<TARGET_FILE_DIR:autools>
    $<TARGET_FILE_DIR:autools_tests>
)

gtest_discover_tests(autools_tests
  WORKING_DIRECTORY $<TARGET_FILE_DIR:autools_tests>)
