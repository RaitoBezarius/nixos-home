function urun()
{
  local OVMF="$(nix-build '<nixpkgs>' -A pkgs.OVMF.fd)"
  local ESP_LOCATION="${ESP:-$(pwd)/esp}"
  local ARCH_STRING="${ARCH:-x86_64}"
  nix-shell -p uefi-run -p qemu --run uefi-run --qemu-path "qemu-system-$(ARCH_STRING)" --bios-path "$OVMF/FV/OVMF.fd" "$@" --drive format=raw,file=fat:rw:${ESP_LOCATION}
}

function uefi_iso_run()
{
  local OVMF="$(nix-build '<nixpkgs>' -A pkgs.OVMF.fd)"
  local ARCH_STRING="${ARCH:-x86_64}"
  nix-shell -p qemu --run "qemu-system-$ARCH_STRING -s -global isa-debugcon.iobase=0x402 -debugcon file:uefi.log -bios \"$OVMF/FV/OVMF.fd\" -net none -nographic -boot d -cdrom $*"
}

function lurun()
{
  local OVMF="$(nix-build -E 'let pkgs = (import <nixpkgs> {}); in (pkgs.enableDebugging (pkgs.OVMF.override { debug = true; sourceDebug = false; })).fd')"
  local ESP_LOCATION="${ESP:-$(pwd)/esp}"
  local ARCH_STRING="${ARCH:-x86_64}"
  nix-shell -p uefi-run -p qemu --run "qemu-system-$ARCH_STRING -s -global isa-debugcon.iobase=0x402 -debugcon file:uefi.log -bios \"$OVMF/FV/OVMF.fd\" -net none -nographic --drive format=raw,file=fat:rw:${ESP_LOCATION}" "$@"
}
