local ls = require "luasnip"
local parse = ls.parser.parse_snippet

local cmake_template = [[
cmake_minimum_required(VERSION 3.10)
project(${1:project})
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/bin)
file(GLOB SOURCES src/*.cpp)
add_executable(${2:app} \$SOURCES)
target_include_directories(${2:app} PRIVATE include)
]]

ls.add_snippets("cmake", {
    parse({ trig = "template" }, cmake_template),
}, {})
