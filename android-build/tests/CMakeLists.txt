# Focused tests use the real common/database/shared libraries, without game or
# external GoogleTest downloads. Enable with -DASHEN_BUILD_COMPAT_TESTS=ON.
if(NOT TARGET shared)
  message(FATAL_ERROR "Compatibility tests require APPS_BUILD=all or auth-only")
endif()

add_executable(ashen_compat_tests CompatibilityTests.cpp)
target_link_libraries(ashen_compat_tests PRIVATE shared acore-core-interface)

# glibc accepts resolver flags that Bionic rejects. Exercise Android's flag
# validation during Linux host tests as well; Android uses its real resolver.
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  target_sources(ashen_compat_tests PRIVATE AndroidResolverFlags.cpp)
  target_link_options(ashen_compat_tests PRIVATE "-Wl,--wrap=getaddrinfo")
endif()
add_test(NAME ashen_compatibility COMMAND ashen_compat_tests)
set_tests_properties(ashen_compatibility PROPERTIES TIMEOUT 30)
