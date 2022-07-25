/**
 * @file demomode.h
 *
 * Contains most of the the demomode specific logic
 */
#pragma once

#include "miniwin/misc_msg.h"

namespace devilution {

namespace demo {

void InitPlayBack(int demoNumber, bool timedemo);
void InitRecording(int recordNumber, bool createDemoReference);
void OverrideOptions();

bool IsRunning();
bool IsRecording();

bool GetRunGameLoop(bool &drawGame, bool &processInput);
bool FetchMessage(tagMSG *lpMsg);
void RecordGameLoopResult(bool runGameLoop);
void RecordMessage(tagMSG *lpMsg);

void NotifyGameLoopStart();
void NotifyGameLoopEnd();

} // namespace demo

} // namespace devilution
