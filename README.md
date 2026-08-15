# utu

`utu` uses the [loris](https://github.com/kellyfitz/loris) library to provide
sound analysis, synthesis, and morphing functionality. `utu` defines an
alternative JSON based file format for partial data to allow the analysis output
to be used in a wide number of environments.

## building

`utu` requires a C++17 capable compiler, tested compilers include:

| compiler | version | platform | os |
| -------- | ------- | -------- | -- |
| gcc | 10.2.1 20210110 | aarch64-linux-gnu | Debian Bullseye |
| clang | Apple clang version 13.0.0 | arm64-apple-darwin21.2.0 | Monterey |
| clang | Apple clang version 13.0.0 | x86_64-apple-darwin20.6.0 | Big Sur |
| msvc | 19.44.35225.0 | x86_64-pc-windows-msvc | Windows 11 |


### dependencies

`utu` builds and statically links several third party libraries from source.

on linux:

```
sudo apt install cmake libasound2-dev
```

on macos:

```
brew install cmake ninja
```

FFTW 3 is optional but recommended. Without it, Loris uses a bundled FFT and
infrequent non-power-of-two transforms are slower.

on linux: `sudo apt install libfftw3-dev`

on macos: `brew install fftw`

### building

once dependencies are installed building `utu` itself can be done as follows:

```
git clone ssh://git@github.com/madronalabs/utu.git
cd utu
git submodule update --init --depth 1
mkdir build
cd build
cmake ..
cmake --build .
./bin/Debug/utu --help
```

on windows (Visual Studio / MSVC only):

MSVC's `std::regex` cannot parse utu's usage string, so the build vendors
[Boost.Regex](https://www.boost.org/doc/libs/release/libs/regex/) in standalone
mode (no other Boost libraries, no vcpkg). Linux and macOS do not use it.

Visual Studio is multi-config, so pass `--config` and run the executable from
the matching output directory (`bin\Debug` or `bin\Release`). The Windows
executable links the static CRT (`/MT` / `/MTd`), so it does not need the
Visual C++ redistributable.

```
cmake --build . --config Debug
bin\Debug\utu.exe --help

cmake --build . --config Release
bin\Release\utu.exe --help
```
