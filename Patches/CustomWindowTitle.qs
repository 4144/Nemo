//##############################################################################
//# Purpose: Switch "Ragnarok" reference with address of User specified Window #
//#          Title which will be that of unused URL string that is overwritten #
//##############################################################################

function CustomWindowTitle()
{
    //Step 1a - Find the offset of the URL to overwrite
    var strOff = exe.findString("http://ro.hangame.com/login/loginstep.asp?prevURL=/NHNCommon/NHN/Memberjoin.asp", RAW);
    if (strOff === -1)
        return "Failed in Step 1";

    //Step 1b - Get the new Title of 'Ragnarok' or 'Ragnarok : Zero' from User
    var getUserInput = "Ragnarok";
        if (IsZero())
        getUserInput = "Ragnarok : Zero";

    var title = exe.getUserInput("$customWindowTitle", XTYPE_STRING, _("String Input - maximum 60 characters"), _("Enter the new window Title"), getUserInput, 1, 60);
    if (title.trim() === getUserInput)
        return "Patch Cancelled - New Title is same as old";

    //Step 1c - Overwrite URL with the new Title
    exe.replace(strOff, "$customWindowTitle", PTYPE_STRING);

    //Step 2a - Find offset of of 'Ragnarok' or 'Ragnarok : Zero'
    var code = " C7 05 ?? ?? ?? 00" + exe.findString("Ragnarok", RVA).packToHex(4); //MOV DWORD PTR DS:[g_title], OFFSET addr; ASCII "Ragnarok"
    if (IsZero())
        code = " C7 05 ?? ?? ?? 00" + exe.findString("Ragnarok : Zero", RVA).packToHex(4); //MOV DWORD PTR DS:[g_title], OFFSET addr; ASCII "Ragnarok : Zero"

    //Step 2b - Find its reference
    var offset = pe.findCode(code);
    if ( offset === -1)
        return "Failed in Step 2";

    //Step 3 - Replace the original reference with the URL offset.
    exe.replaceDWord(offset + code.hexlength() - 4, exe.Raw2Rva(strOff));

    return true;
}
