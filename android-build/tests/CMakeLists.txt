# Focused tests use the real common/database/shared libraries, without game or
# external GoogleTest downloads. Enable with -DASHEN_BUILD_COMPAT_TESTS=ON.
if(NOT TARGET shared)
  message(FATAL_ERROR "Compatibility tests require APPS_BUILD=all or auth-only")
endif()

add_executable(ashen_compat_tests CompatibilityTests.cpp)
target_link_libraries(ashen_compat_tests PRIVATE shared acore-core-interface)
add_test(NAME ashen_compatibility COMMAND ashen_compat_tests)
set_tests_properties(ashen_compatibility PROPERTIES TIMEOUT 30)
