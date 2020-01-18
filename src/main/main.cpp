#include <hello/hello.h>
#include <iostream>

int main(int argc, char* argv[]) {
    const HelloWorld hello;
    std::cout << hello.get_hello() << std::endl;
    return 0;
}
