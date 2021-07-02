#include <fmod_errors.h>

#include <cstdint>
#include <fmod.hpp>
#include <iostream>

void ERRCHECK(FMOD_RESULT result) {
  if (result != FMOD_OK) {
    std::cerr << FMOD_ErrorString(result) << '\n';
    exit(EXIT_FAILURE);
  }
}
