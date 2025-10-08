#include <SDL2/SDL.h>
#include "chibi/eval.h"

typedef struct {
    SDL_Window* window;
    SDL_Renderer* renderer;
} SDLContext;

typedef struct {
  sexp ctx;
  sexp env;
  sexp init_proc;
  sexp update_proc;
  sexp render_proc;

  SDLContext sdl_ctx;
} app_state_t;

extern app_state_t* global_state;
