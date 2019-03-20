#! /bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: graal.sh <llvm directory>"
	exit -1
fi

llvm_root="$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"

echo "Refactoring X86 target..."

find $llvm_root -type d -name "*" -exec rename 's/x86/graal86/g' {} +
find $llvm_root -type d -name "*" -exec rename 's/X86/Graal86/g' {} +
find $llvm_root -type f -name "*" -exec rename 's/x86/graal86/g' {} +
find $llvm_root -type f -name "*" -exec rename 's/X86/Graal86/g' {} +
find $llvm_root -type f -name "*" -exec sed -i -E 's/x86/graal86/g' {} +
find $llvm_root -type f -name "*" -exec sed -i -E 's/X86/Graal86/g' {} +

# Revert excessive refactoring
find $llvm_root -type f -name "*" -exec sed -i -E 's/0graal86/0x86/g' {} +

# Avoid duplicate option definitions
sed -i 's/asan-instrument-assembly/graal-asan-instrument-assembly/g' $llvm_root/lib/Target/Graal86/AsmParser/Graal86AsmInstrumentation.cpp
sed -i 's/mark-data-regions/graal-mark-data-regions/g' $llvm_root/lib/Target/Graal86/MCTargetDesc/Graal86MCAsmInfo.cpp
sed -i 's/fixup-byte-word-insts/graal-fixup-byte-word-insts/g' $llvm_root/lib/Target/Graal86/Graal86FixupBWInsts.cpp
sed -i 's/mul-constant-optimization/graal-mul-constant-optimization/g' $llvm_root/lib/Target/Graal86/Graal86ISelLowering.cpp
sed -i 's/disable-spill-fusing/graal-disable-spill-fusing/g' $llvm_root/lib/Target/Graal86/Graal86InstrInfo.cpp
sed -i 's/print-failed-fuse-candidates/graal-print-failed-fuse-candidates/g' $llvm_root/lib/Target/Graal86/Graal86InstrInfo.cpp
sed -i 's/remat-pic-stub-load/graal-remat-pic-stub-load/g' $llvm_root/lib/Target/Graal86/Graal86InstrInfo.cpp
sed -i 's/partial-reg-update-clearance/graal-partial-reg-update-clearance/g' $llvm_root/lib/Target/Graal86/Graal86InstrInfo.cpp
sed -i 's/undef-reg-clearance/graal-undef-reg-clearance/g' $llvm_root/lib/Target/Graal86/Graal86InstrInfo.cpp

echo "Building X86 shared library..."
rm -rf build
mkdir build
cd build

cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="Graal86" -DLLVM_LINK_LLVM_DYLIB=ON $llvm_root -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_ASSERTIONS=ON
ninja

echo "Library written to build/lib/Graal86.[dylib|so]"
