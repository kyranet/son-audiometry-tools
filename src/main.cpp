#include <cstdint>
#include <fmod.hpp>

#include "shared/errors.h"

int main() {
  FMOD::System* system;
  ERRCHECK(FMOD::System_Create(&system));
  ERRCHECK(system->init(128, FMOD_INIT_NORMAL, 0));

  ERRCHECK(system->release());
  return EXIT_SUCCESS;
}
