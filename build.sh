rm -rf build
mkdir build
cd build
cmake .. -DFLEX_EXECUTABLE=/opt/homebrew/opt/flex/bin/flex -DFLEX_INCLUDE_DIR=/opt/homebrew/opt/flex/include -DFL_LIBRARY=/opt/homebrew/opt/flex/lib/libfl.dylib
make