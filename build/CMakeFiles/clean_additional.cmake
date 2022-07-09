# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/SSIMP_pc_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/SSIMP_pc_autogen.dir/ParseCache.txt"
  "CMakeFiles/appSSIMP_pc_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appSSIMP_pc_autogen.dir/ParseCache.txt"
  "SSIMP_pc_autogen"
  "appSSIMP_pc_autogen"
  )
endif()
