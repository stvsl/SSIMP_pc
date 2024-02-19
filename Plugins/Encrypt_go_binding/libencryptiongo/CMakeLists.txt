add_library(crypto SHARED)
add_custom_command(
    TARGET crypto
    POST_BUILD
    COMMAND echo "Building Go plugins."
    COMMAND go build -o ${CMAKE_CURRENT_BINARY_DIR}/libcrypto.so -buildmode=c-shared ${CMAKE_CURRENT_SOURCE_DIR}/main.go
    COMMENT "******************************编译Go组件******************************"
)

add_custom_command(
    TARGET crypto
    POST_BUILD
    COMMAND echo "Copying Go plugins."
    COMMAND cp ${CMAKE_CURRENT_BINARY_DIR}/libcrypto.h ${CMAKE_CURRENT_SOURCE_DIR}/../../include/libcrypto.h
    COMMENT "******************************拷贝Go组件******************************"
)
