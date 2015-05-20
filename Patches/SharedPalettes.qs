// All have same procedure - Only format strings are different
function SharedBodyPalettesV1() {
  // "��\%s_%s_%d.pal" => "��\body%.s_%s_%d.pal"
  
  return SharedPalettes("\xB8\xF6\\", "\xB8\xF6\\body%.s_%s_%d.pal\x00"); //%.s is required. Skips jobname
}

function SharedBodyPalettesV2() {
  // "��\%s_%s_%d.pal" => "��\body%.s%.s_%d.pal"
  
  return SharedPalettes("\xB8\xF6\\", "\xB8\xF6\\body%.s%.s_%d.pal\x00"); //%.s is required. Skips jobname & gender
}

function SharedHeadPalettesV1() {
  // "�Ӹ�\�Ӹ�%s_%s_%d.pal" => "�Ӹ�\head%.s_%s_%d.pal"
  
  return SharedPalettes("\xB8\xD3\xB8\xAE\\\xB8\xD3\xB8\xAE", "\xB8\xD3\xB8\xAE\\head%.s_%s_%d.pal\x00");// %.s is required. Skips jobname
}

function SharedHeadPalettesV2() {
  // "�Ӹ�\�Ӹ�%s_%s_%d.pal" => "�Ӹ�\head%.s%.s_%d.pal"
  
  return SharedPalettes("\xB8\xD3\xB8\xAE\\\xB8\xD3\xB8\xAE", "\xB8\xD3\xB8\xAE\\head%.s%.s_%d.pal\x00");// %.s is required. Skips jobname & gender
}

function SharedPalettes(prefix, newString) {
  ////////////////////////////////////////////////////////////////////
  // GOAL: Modify the format string in CSession::GetBodyPaletteName //
  //       (for Body) or CSession::GetHeadPaletteName (for Head)    //
  //       used for constructing Palette filename to skip parts.    //
  ////////////////////////////////////////////////////////////////////
  
  //Step 1a - Find address of original Format String
  var offset = exe.findString(prefix + "%s%s_%d.pal", RVA);//<prefix>%s%s_%d.pal - Old Format
  
  if (offset === -1)
    offset = exe.findString(prefix + "%s_%s_%d.pal", RVA);//<prefix>%s_%s_%d.pal - New Format
  
  if (offset === -1)
    return "Failed in Step 1 - Format String missing";

  //Step 1b - Find its reference
  offset = exe.findCode("68" + offset.packToHex(4), PTYPE_HEX, false);
  if (offset === -1)
    return "Failed in Step 1 - Format String reference missing";
    
  //Step 2a - Allocate space for New Format String - Original address don't have enough space for some scenarios.
  var offset2 = exe.findZeros(newString.length);
  if (offset2 === -1)
    return "Failed in Step 2";
  
  //Step 2b - Insert the new format string
  exe.insert(offset2, newString.length, newString, PTYPE_STRING);
  
  //Step 3 - Replace with new one's address
  exe.replace(offset+1, exe.Raw2Rva(offset2).packToHex(4), PTYPE_HEX);
  
  return true;
}