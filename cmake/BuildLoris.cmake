include(FindPkgConfig)

# Static overlay over kellyfitz/loris v2.0. Do not add_subdirectory(vendor/loris):
# upstream's CMakeLists.txt is a standalone project (shared lib, CTest, Python).
# Keep the source lists in sync with vendor/loris/src/CMakeLists.txt when bumping
# the submodule.
set(loris_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/vendor/loris)

enable_language(C)

pkg_check_modules(FFTW fftw3 IMPORTED_TARGET)

# Version macros substituted into src/loris.h.in (v2.0 tag).
set(LORIS_MAJOR_VERSION 2)
set(LORIS_MINOR_VERSION 0)
set(LORIS_SUBMINOR_VERSION 0)
set(LORIS_PRERELEASE_STR "")
set(LORIS_VERSION_STR "Loris ${LORIS_MAJOR_VERSION}.${LORIS_MINOR_VERSION}${LORIS_PRERELEASE_STR}")

set(loris_gen_dir ${CMAKE_CURRENT_BINARY_DIR}/loris-gen)
configure_file(
  ${loris_SOURCE_DIR}/src/loris.h.in
  ${loris_gen_dir}/loris.h
  @ONLY
)

# Public include layout matching the installed API: <loris/Analyzer.h>
set(loris_wrap_dir ${CMAKE_CURRENT_BINARY_DIR}/loris-include)
file(MAKE_DIRECTORY ${loris_wrap_dir})
file(REMOVE ${loris_wrap_dir}/loris)
file(CREATE_LINK ${loris_SOURCE_DIR}/src ${loris_wrap_dir}/loris SYMBOLIC)

set(loris_src ${loris_SOURCE_DIR}/src)

set(LORIS_CPP_SRC
  ${loris_src}/AiffData.cpp
  ${loris_src}/AiffFile.cpp
  ${loris_src}/Analyzer.cpp
  ${loris_src}/AssociateBandwidth.cpp
  ${loris_src}/BigEndian.cpp
  ${loris_src}/Breakpoint.cpp
  ${loris_src}/BreakpointUtils.cpp
  ${loris_src}/Channelizer.cpp
  ${loris_src}/Collator.cpp
  ${loris_src}/Dilator.cpp
  ${loris_src}/Distiller.cpp
  ${loris_src}/Envelope.cpp
  ${loris_src}/F0Estimate.cpp
  ${loris_src}/LorisExceptions.cpp
  ${loris_src}/Filter.cpp
  ${loris_src}/FourierTransform.cpp
  ${loris_src}/FrequencyReference.cpp
  ${loris_src}/Fundamental.cpp
  ${loris_src}/Harmonifier.cpp
  ${loris_src}/ImportLemur.cpp
  ${loris_src}/KaiserWindow.cpp
  ${loris_src}/LinearEnvelope.cpp
  ${loris_src}/Marker.cpp
  ${loris_src}/Morpher.cpp
  ${loris_src}/NoiseGenerator.cpp
  ${loris_src}/Notifier.cpp
  ${loris_src}/Oscillator.cpp
  ${loris_src}/Partial.cpp
  ${loris_src}/PartialBuilder.cpp
  ${loris_src}/PartialList.cpp
  ${loris_src}/PartialUtils.cpp
  ${loris_src}/phasefix.cpp
  ${loris_src}/ReassignedSpectrum.cpp
  ${loris_src}/Resampler.cpp
  ${loris_src}/SdifFile.cpp
  ${loris_src}/Sieve.cpp
  ${loris_src}/SpcFile.cpp
  ${loris_src}/SpectralPeakSelector.cpp
  ${loris_src}/SpectralSurface.cpp
  ${loris_src}/Synthesizer.cpp
  ${loris_src}/fftsg.c
)

set(LORIS_PI_SRC
  ${loris_src}/lorisAnalyzer_pi.cpp
  ${loris_src}/lorisBpEnvelope_pi.cpp
  ${loris_src}/lorisException_pi.cpp
  ${loris_src}/lorisNonObj_pi.cpp
  ${loris_src}/lorisPartialList_pi.cpp
  ${loris_src}/lorisUtilities_pi.cpp
)

set(LORIS_FASTSYNTH_SRC
  ${loris_src}/fast-synth-src/BlockOscillator.cpp
  ${loris_src}/fast-synth-src/BlockSynthBwe.cpp
  ${loris_src}/fast-synth-src/BlockSynthReader.cpp
  ${loris_src}/fast-synth-src/r250.c
  ${loris_src}/fast-synth-src/randlcg.c
)

add_library(loris STATIC ${LORIS_CPP_SRC} ${LORIS_PI_SRC} ${LORIS_FASTSYNTH_SRC})
target_compile_features(loris PUBLIC cxx_std_17)
target_compile_definitions(loris PUBLIC FASTSYNTH_FLOAT_TYPE=double)
target_compile_options(loris PRIVATE -Wno-comment)
target_include_directories(loris
  SYSTEM PUBLIC
    ${loris_wrap_dir}
  PRIVATE
    ${loris_gen_dir}
    ${loris_src}
    ${loris_src}/fast-synth-src
)

if(FFTW_FOUND)
  target_compile_definitions(loris PRIVATE HAVE_FFTW3_H=1)
  target_link_libraries(loris PUBLIC PkgConfig::FFTW)
endif()

if(NOT APPLE)
  target_link_libraries(loris PRIVATE m)
endif()

add_library(loris::loris ALIAS loris)
