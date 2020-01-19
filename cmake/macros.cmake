
function(skel_add_dependencies)
    cmake_parse_arguments(ARG "" "TARGET" "LIBRARIES" ${ARGN})
    foreach(_library ${ARG_LIBRARIES})

        get_target_property(targettype "${ARG_TARGET}" TYPE)

        if(TARGET "${_library}")
            get_target_property(libtype "${_library}" TYPE)
            add_dependencies(
                "${ARG_TARGET}"
                ${_library}
            )
        else()
            set(libtype "UNKNOWN")
        endif()

        if(NOT "${libtype}" STREQUAL "INTERFACE_LIBRARY")
            if(NOT "${targettype}" STREQUAL "INTERFACE_LIBRARY")
                target_link_libraries(
                    "${ARG_TARGET}"
                    ${_library}
                )
            endif()
        endif()
    endforeach(_library)
endfunction()

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

    skel_add_dependencies(TARGET "${ARG_TARGET}" LIBRARIES ${ARG_LIBRARIES})

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

    if (NOT "${LIB_TYPE}" STREQUAL "INTERFACE")
        set_target_properties(
            "${ARG_TARGET}"
            PROPERTIES PUBLIC_HEADER "${HEADERS}"
        )
    endif()

    install(
        TARGETS "${ARG_TARGET}"
        LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${ARG_DESTINATION}"
    )

endfunction()


function(skel_add_executable)

    cmake_parse_arguments(ARG "" "TARGET" "SOURCES;LIBRARIES" ${ARGN})

    add_executable(
        "${ARG_TARGET}"
        ${ARG_SOURCES}
    )

    skel_add_dependencies(TARGET "${ARG_TARGET}" LIBRARIES ${ARG_LIBRARIES})

endfunction()


function(skel_add_test)

    cmake_parse_arguments(ARG "" "TARGET" "SOURCES;LIBRARIES" ${ARGN})

    skel_add_executable(TARGET "${ARG_TARGET}" SOURCES "${ARG_SOURCES}" LIBRARIES ${ARG_LIBRARIES})

    add_test(
        "${ARG_TARGET}"
        "${EXECUTABLE_OUTPUT_PATH}/${ARG_TARGET}"
    )

endfunction()
