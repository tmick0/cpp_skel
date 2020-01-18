function(skel_add_library)

    cmake_parse_arguments(ARG "INTERFACE;STATIC;SHARED" "TARGET;DESTINATION" "SOURCES;HEADERS;LIBRARIES" ${ARGN})

    set(LIB_TYPE "")
    if(ARG_SHARED)
        set(LIB_TYPE "SHARED")
    else()
        if(ARG_STATIC)
            set(LIB_TYPE "STATIC")
        else()
            if(ARG_INTERFACE)
                set(LIB_TYPE "INTERFACE")
            endif()
        endif()
    endif()

    add_library(
        "${ARG_TARGET}"
        "${LIB_TYPE}"
        ${ARG_SOURCES}
    )

    if(ARG_LIBRARIES)
        target_link_libraries(
            "${ARG_TARGET}"
            ${ARG_LIBRARIES}
        )
        add_dependencies(
            "${ARG_TARGET}"
            ${ARG_LIBRARIES}
        )
    endif()

    foreach(_header ${ARG_HEADERS})
        add_custom_target(
            "${ARG_TARGET}_header_${_header}"
        )
        add_custom_command(
            TARGET "${ARG_TARGET}_header_${_header}"
            PRE_BUILD COMMAND mkdir -p "${HEADER_OUTPUT_PATH}/${ARG_DESTINATION}"
        )
        add_custom_command(
            TARGET "${ARG_TARGET}_header_${_header}"
            PRE_BUILD COMMAND ln -fs "${CMAKE_CURRENT_LIST_DIR}/${_header}" "${HEADER_OUTPUT_PATH}/${ARG_DESTINATION}/${_header}" 
        )
        add_custom_command(
            TARGET "${ARG_TARGET}_header_${_header}"
            PRE_BUILD COMMAND echo ln -fs "${CMAKE_CURRENT_LIST_DIR}/${_header}" "${HEADER_OUTPUT_PATH}/${ARG_DESTINATION}/${_header}" 
        )
        add_dependencies("${ARG_TARGET}" "${ARG_TARGET}_header_${_header}")
    endforeach(_header)

    set_target_properties(
        "${ARG_TARGET}"
        PROPERTIES PUBLIC_HEADER "${HEADERS}"
    )

    install(
        TARGETS "${ARG_TARGET}"
        LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${ARG_DESTINATION}"
    )

endfunction()


function(skel_add_test)

    cmake_parse_arguments(ARG "" "TARGET" "SOURCES;LIBRARIES" ${ARGN})

    add_executable(
        "${ARG_TARGET}"
        ${ARG_SOURCES}
    )

    if(ARG_LIBRARIES)
        target_link_libraries(
            "${ARG_TARGET}"
            ${ARG_LIBRARIES}
        )
        add_dependencies(
            "${ARG_TARGET}"
            ${ARG_LIBRARIES}
        )
    endif()

    add_test(
        "${ARG_TARGET}"
        "${EXECUTABLE_OUTPUT_PATH}/${ARG_TARGET}"
    )

endfunction()