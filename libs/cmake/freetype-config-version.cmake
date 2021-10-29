# Version extraction logic 'inspired' from: https://github.com/Kitware/CMake/blob/master/Modules/FindFreetype.cmake
file(STRINGS "${CMAKE_CURRENT_LIST_DIR}/../freetype2/include/freetype/freetype.h" freetype_version_str
       REGEX "^#[\t ]*define[\t ]+FREETYPE_(MAJOR|MINOR|PATCH)[\t ]+[0-9]+$")

unset(PACKAGE_VERSION)
foreach(VPART MAJOR MINOR PATCH)
    foreach(VLINE ${freetype_version_str})
        if(VLINE MATCHES "^#[\t ]*define[\t ]+FREETYPE_${VPART}[\t ]+([0-9]+)$")
            set(FREETYPE_VERSION_PART "${CMAKE_MATCH_1}")
            if(PACKAGE_VERSION)
                string(APPEND PACKAGE_VERSION ".${FREETYPE_VERSION_PART}")
            else()
                set(PACKAGE_VERSION "${FREETYPE_VERSION_PART}")
            endif()
            unset(FREETYPE_VERSION_PART)
        endif()
    endforeach()
endforeach()

if(PACKAGE_VERSION VERSION_LESS PACKAGE_FIND_VERSION)
  set(PACKAGE_VERSION_COMPATIBLE FALSE)
else()
  set(PACKAGE_VERSION_COMPATIBLE TRUE)
  if(PACKAGE_FIND_VERSION STREQUAL PACKAGE_VERSION)
    set(PACKAGE_VERSION_EXACT TRUE)
  endif()
endif()