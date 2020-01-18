# cpp_skel

Skeleton for a CMake-based C++ project

## Macros provided

```cmake
skel_add_library(
    TARGET library_name (INTERFACE|STATIC|SHARED)
    SOURCES source_files...
    HEADERS headers...
    LIBRARIES libs_to_link...
    DESTINATION install_prefix
)

skel_add_test(
    TARGET test_name
    SOURCES source_files...
    LIBRARIES libs_to_link...
)
```

This project will automatically include GTest, and you will be able to link against `gtest_main` to use it in your tests. Tests will be registered with `ctest` automatically.
