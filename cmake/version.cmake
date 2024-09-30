
macro(HEXCHAR2DEC VAR VAL)
    if(${VAL} MATCHES "[0-9]")
        SET(${VAR} ${VAL})
    elseif(${VAL} MATCHES "[aA]")
        SET(${VAR} 10)
    elseif(${VAL} MATCHES "[bB]")
        SET(${VAR} 11)
    elseif(${VAL} MATCHES "[cC]")
        SET(${VAR} 12)
    elseif(${VAL} MATCHES "[dD]")
        SET(${VAR} 13)
    elseif(${VAL} MATCHES "[eE]")
        SET(${VAR} 14)
    elseif(${VAL} MATCHES "[fF]")
        SET(${VAR} 15)
    else()
        MESSAGE(FATAL_ERROR "Invalid format for hexidecimal character")
    endif()
endmacro(HEXCHAR2DEC)

macro(HEX2DEC VAR VAL)
    SET(CURINDEX 0)
    STRING(LENGTH "${VAL}" CURLENGTH)
    SET(${VAR} 0)
    while(CURINDEX LESS CURLENGTH)
        STRING(SUBSTRING "${VAL}" ${CURINDEX} 1 CHAR)
        HEXCHAR2DEC(CHAR ${CHAR})
        MATH(EXPR POWAH "(1<<((${CURLENGTH}-${CURINDEX}-1)*4))")
        MATH(EXPR CHAR "(${CHAR}*${POWAH})")
        MATH(EXPR ${VAR} "${${VAR}}+${CHAR}")
        MATH(EXPR CURINDEX "${CURINDEX}+1")
    endwhile()
endmacro(HEX2DEC)

macro(SET_VERSION MAJOR MINOR FILE)
    file(READ ${FILE} ver)
    string(REGEX MATCHALL "0x([0-9A-F])([0-9A-F])([0-9A-F])([0-9A-F])" _ ${ver})
    string(CONCAT ver_major ${CMAKE_MATCH_1}${CMAKE_MATCH_2})
    string(CONCAT ver_minor ${CMAKE_MATCH_3}${CMAKE_MATCH_4})
    HEX2DEC(ver_major ${ver_major})
    HEX2DEC(ver_minor ${ver_minor})
    message(STATUS "Found version:\t\t ${ver_major}.${ver_minor}")
    if(NOT ENABLE_EMULATION AND NOT ESP_PLATFORM)
        pico_set_binary_version(${CMAKE_PROJECT_NAME} MAJOR ${ver_major} MINOR ${ver_minor})
    endif()
    SET(${MAJOR} ${ver_major})
    SET(${MINOR} ${ver_minor})
endmacro(SET_VERSION)
