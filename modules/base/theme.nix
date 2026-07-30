{ lib, ... }:

{
  flake.theme =
    let
      toRGB =
        let
          slice = p: h: builtins.substring p 2 h;
          dec = h: lib.fromHexString h;
        in
        hex: {
          r = dec (slice 1 hex);
          g = dec (slice 3 hex);
          b = dec (slice 5 hex);
        };

      fromRGB =
        let
          slice = h: builtins.substring (builtins.stringLength h - 6) 6 h;
          f = n: lib.toHexString n;
        in
        {
          r,
          g,
          b,
        }:
        "#" + slice ("000000" + (f (r * 65536 + g * 256 + b)));

      brighten =
        v: h:
        let
          rgb = toRGB h;
          lerp =
            n:
            let
              res = n + (builtins.floor ((255 - n) * v));
            in
            if res < 0 then
              0
            else if res > 255 then
              255
            else
              res;
        in
        fromRGB {
          r = lerp rgb.r;
          g = lerp rgb.g;
          b = lerp rgb.b;
        };
    in
    {
      base00 = "#0e1014";
      base01 = "#282a2d";
      base02 = "#424547";
      base03 = "#5c5f60";
      base04 = "#77797a";
      base05 = "#919393";
      base06 = "#abaead";
      base07 = "#c5c8c6";
      base08 = "#ff700f";
      base09 = "#f9a824";
      base0A = "#fdd41d";
      base0B = "#ceff1f";
      base0C = "#1fff57";
      base0D = "#1fff75";
      base0E = "#d8466f";
      base0F = "#ea3458";
      inherit toRGB fromRGB brighten;
    };
}
