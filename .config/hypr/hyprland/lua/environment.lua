local environment = {
    XDG_CURRENT_DESKTOP = "Hyprland",
    XDG_SESSION_DESKTOP = "Hyprland",
    XDG_SESSION_TYPE = "wayland",
    MOZ_ENABLE_WAYLAND = "1",
    QT_AUTO_SCREEN_SCALE_FACTOR = "1",
    QT_QPA_PLATFORM = "wayland;xcb",
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",
    QT_QPA_PLATFORMTHEME = "qt5ct",
    QT_IM_MODULE = "fcitx",
    XMODIFIERS = "@im=fcitx",
    GTK_IM_MODULE = "fcitx",
    SDL_IM_MODULE = "fcitx",
    GLFW_IM_MODULE = "ibus",
    INPUT_METHOD = "fcitx",
    GDK_BACKEND = "wayland,x11,*",
    GTK_THEME = "Adwaita:dark",
    GDK_SCALE = "1.5",
    XCURSOR_SIZE = "24",
}

for name, value in pairs(environment) do
    hl.env(name, value)
end
