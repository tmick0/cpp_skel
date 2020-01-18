#include <gtest/gtest.h>
#include <hello/hello.h>

TEST(HelloWorld, get_hello) {
    const HelloWorld h;
    ASSERT_EQ("hello world", h.get_hello());
}
