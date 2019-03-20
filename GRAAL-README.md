# How to build Graal target libraries for a new version of LLVM

1. Create a new branch from the tag branch: `git checkout -b oracle/x.x.x tags/llvmorg-x.x.x`
2. Cherry-pick the commit on top of the previous branch: `git cherry-pick oracle/y.y.y`
3. Resolve the potential merge conflicts
4. Follow the instructions below to generate the library

# How to generate the target library

1. Run `graal.sh llvm/` from the root of the repo
2. The compiled shared library is in `build/lib/<target name>.so` (Linux) or `build/lib/<target name>.dylib` (macOS)