{ lib }:
{
  obfuscate = email: lib.strings.concatStrings (
    lib.reverseList (lib.strings.stringToCharacters email)
  );
}
