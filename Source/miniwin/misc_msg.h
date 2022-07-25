/**
 * @file miniwin/misc_msg.h
 *
 * Contains most of the the demomode specific logic
 */
#pragma once

#include <SDL.h>
#include <cstdint>

#ifdef USE_SDL1
#include "utils/sdl2_to_1_2_backports.h"
#endif

#include "engine/point.hpp"

namespace devilution {

struct tagMSG {
	uint32_t message;
	uint32_t wParam;
	uint16_t lParam;
};

typedef void (*EventHandler)(uint32_t, uint32_t, uint16_t);

void SetCursorPos(Point position);
void FocusOnCharInfo();

void SetMouseButtonEvent(SDL_Event &event, uint32_t type, uint8_t button, Point position);
bool FetchMessage(tagMSG *lpMsg);

void PushMessage(const tagMSG *lpMsg);
void PostMessage(uint32_t type, uint32_t wParam, uint16_t lParam);
void ClearMessageQueue();

//
// Events
//
#define DVL_WM_QUIT 0x0012

#define DVL_WM_MOUSEMOVE 0x0200
#define DVL_WM_LBUTTONDOWN 0x0201
#define DVL_WM_LBUTTONUP 0x0202
#define DVL_WM_RBUTTONDOWN 0x0204
#define DVL_WM_RBUTTONUP 0x0205
#define DVL_WM_MBUTTONDOWN 0x0206
#define DVL_WM_MBUTTONUP 0x0207
#define DVL_WM_X1BUTTONDOWN 0x0208
#define DVL_WM_X1BUTTONUP 0x0209
#define DVL_WM_X2BUTTONDOWN 0x020A
#define DVL_WM_X2BUTTONUP 0x020B

#define DVL_WM_KEYDOWN 0x0100
#define DVL_WM_KEYUP 0x0101

#define DVL_WM_CAPTURECHANGED 0x0215

#define DVL_WM_PAINT 0x000F
#define DVL_WM_QUERYENDSESSION 0x0011

} // namespace devilution
