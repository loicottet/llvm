#! /bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: graal-aarch64.sh <llvm directory>"
	exit -1
fi

llvm_root="$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"

echo "Refactoring AArch64 target..."

find $llvm_root -type d -name "*" -exec rename 's/aarch64/grarch64/g' {} +
find $llvm_root -type d -name "*" -exec rename 's/AArch64/GrArch64/g' {} +
find $llvm_root -type f -name "*" -exec rename 's/aarch64/grarch64/g' {} +
find $llvm_root -type f -name "*" -exec rename 's/AArch64/GrArch64/g' {} +
find $llvm_root -type f -name "*" -exec sed -i '' -E 's/aarch64/grarch64/g' {} +
find $llvm_root -type f -name "*" -exec sed -i '' -E 's/AArch64/GrArch64/g' {} +

echo "Building AArch64 shared library..."
rm -rf build
mkdir build
cd build

cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="GrArch64" -DLLVM_LINK_LLVM_DYLIB=ON $llvm_root -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_ASSERTIONS=ON
ninja

echo "Library written to build/lib/GrArch64.[dylib|so]"
