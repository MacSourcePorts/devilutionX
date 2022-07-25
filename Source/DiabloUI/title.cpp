#include "DiabloUI/diabloui.h"
#include "control.h"
#include "controls/input.h"
#include "controls/menu_controls.h"
#include "discord/discord.h"
#include "engine/load_pcx.hpp"
#include "utils/language.h"
#include "utils/sdl_geometry.h"
#include "utils/stdcompat/optional.hpp"

namespace devilution {
namespace {

std::optional<OwnedCelSpriteSheetWithFrameHeight> DiabloTitleLogo;

std::vector<std::unique_ptr<UiItemBase>> vecTitleScreen;

void TitleLoad()
{
	if (gbIsHellfire) {
		LoadBackgroundArt("ui_art\\hf_logo1.pcx", 16);
		ArtBackgroundWidescreen = LoadPcxAsCl2("ui_art\\hf_titlew.pcx");
	} else {
		LoadBackgroundArt("ui_art\\title.pcx");
		DiabloTitleLogo = LoadPcxSpriteSheetAsCl2("ui_art\\logo.pcx", /*numFrames=*/15, /*transparentColor=*/250);
	}
}

void TitleFree()
{
	ArtBackground = std::nullopt;
	ArtBackgroundWidescreen = std::nullopt;
	DiabloTitleLogo = std::nullopt;

	vecTitleScreen.clear();
}

} // namespace

void UiTitleDialog()
{
	TitleLoad();
	const Point uiPosition = GetUIRectangle().position;
	if (gbIsHellfire) {
		SDL_Rect rect = MakeSdlRect(0, uiPosition.y, 0, 0);
		if (ArtBackgroundWidescreen)
			vecTitleScreen.push_back(std::make_unique<UiImageCl2>(ArtBackgroundWidescreen->sprite(), rect, UiFlags::AlignCenter));
		vecTitleScreen.push_back(std::make_unique<UiImageAnimatedCl2>(ArtBackground->sheet(), rect, UiFlags::AlignCenter));
	} else {
		UiAddBackground(&vecTitleScreen);

		vecTitleScreen.push_back(std::make_unique<UiImageAnimatedCl2>(
		    DiabloTitleLogo->sheet(), MakeSdlRect(0, uiPosition.y + 182, 0, 0), UiFlags::AlignCenter));

		SDL_Rect rect = MakeSdlRect(uiPosition.x, uiPosition.y + 410, 640, 26);
		vecTitleScreen.push_back(std::make_unique<UiArtText>(_("Copyright © 1996-2001 Blizzard Entertainment").data(), rect, UiFlags::AlignCenter | UiFlags::FontSize24 | UiFlags::ColorUiSilver));
	}

	bool endMenu = false;
	Uint32 timeOut = SDL_GetTicks() + 7000;

	SDL_Event event;
	while (!endMenu && SDL_GetTicks() < timeOut) {
		UiRenderItems(vecTitleScreen);
		UiFadeIn();

		discord_manager::UpdateMenu();

		while (PollEvent(&event) != 0) {
			if (GetMenuAction(event) != MenuAction_NONE) {
				endMenu = true;
				break;
			}
			switch (event.type) {
			case SDL_KEYDOWN:
			case SDL_MOUSEBUTTONUP:
				endMenu = true;
				break;
			}
			UiHandleEvents(&event);
		}
	}

	TitleFree();
}

} // namespace devilution
