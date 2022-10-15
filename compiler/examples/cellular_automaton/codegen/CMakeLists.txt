cmake_minimum_required(VERSION 3.13.4)
project(cellular_automation)

find_package(LLVM REQUIRED CONFIG)
find_package(SFML 2.5 
  COMPONENTS 
    system window graphics network audio REQUIRED)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

include_directories(${LLVM_INCLUDE_DIRS})
separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})

# Now build our tools
add_executable(codegen codegen.cpp ../draw.cpp)

# Find the libraries that correspond to the LLVM components
# that we wish to use
llvm_map_components_to_libnames(
    llvm_libs
    support
    core
    irreader
    ExecutionEngine
)

# Link against LLVM libraries
target_link_libraries(codegen ${llvm_libs} sfml-graphics)