#
#  This file is part of EXT_glpk
#  Copyright (C) 2017  Julien Thevenon ( julien_thevenon at yahoo.fr )
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
#
#.rst:
# FindGlpk
# -------------
#
# Module to locate Glpk library
#
# This module define the following variables
#    Glpk_FOUND
#    Glpk_VERSION
#    Glpk_LIBRARIES
#    Glpk_INCLUDE_DIRS
#
find_package(PkgConfig)
pkg_check_modules(PC_GLPK QUIET libglpk)
if("${PC_GLPK}" STREQUAL "")
    set(GLPK_HINTS $ENV{GLPK_INSTALL})

    set(GLPK_PATHS /usr
        /usr/local/
        /usr/local/share/
        /usr/share/)
    find_path(Glpk_INCLUDE_DIR
              NAMES glpk.h
              PATHS ${GLPK_PATHS}
              HINTS ${GLPK_HINTS}
              PATH_SUFFIXES include
              DOC "Variable storing the location of Glpk header")

    set(ARCH_SUFFIX "x86_64-linux-gnu")
    if("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
      set(ARCH_SUFFIX "")
    endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")

    find_library(Glpk_LIBRARY
              NAMES glpk
              PATHS ${GLPK_PATHS}
              HINTS ${GLPK_HINTS}
              PATH_SUFFIXES "${ARCH_SUFFIX}"
              DOC "Variable storing the location of Glpk library")
    set(Glpk_VERSION ${Glpk_FIND_VERSION})
    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(Glpk
                                      FOUND_VAR Glpk_FOUND
                                      REQUIRED_VARS
                                      Glpk_LIBRARY
                                      Glpk_INCLUDE_DIR
                                      VERSION_VAR Glpk_VERSION
                                      )
    if(Glpk_FOUND)
        set(Glpk_LIBRARIES ${Glpk_LIBRARY})
        set(Glpk_INCLUDE_DIRS ${Glpk_INCLUDE_DIR})
        #set(Glpk_DEFINITIONS ${PC_Glpk_CFLAGS_OTHER})
    endif()
    if(Glpk_FOUND AND NOT TARGET Glpk::Glpk)
        add_library(Glpk::Glpk UNKNOWN IMPORTED)
        set_target_properties(Glpk::Glpk PROPERTIES
        IMPORTED_LOCATION "${Glpk_LIBRARY}"
        INTERFACE_COMPILE_OPTIONS ""
        INTERFACE_INCLUDE_DIRECTORIES "${Glpk_INCLUDE_DIR}")
    endif()
endif("${PC_GLPK}" STREQUAL "")
