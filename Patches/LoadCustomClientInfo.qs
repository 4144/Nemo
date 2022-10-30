//
// Copyright (C) 2017  Secret
// Copyright (C) 2017-2022  Andrei Karas (4144)
//
// This script is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// ################################################
// # Purpose: Change the clientinfo.xml reference #
// #          to custom file specified by user    #
// ################################################

function LoadCustomClientInfo()
{
    var ciName = "sclientinfo.xml";
    var offset = pe.stringVa(ciName);

    if (offset === -1)
    {
        ciName = "clientinfo.xml";
        offset = pe.stringVa(ciName);
    }
    if (offset === -1)
    {
        return "Failed in Step 1a - (s)clientinfo file name not found";
    }

    var offset1 = pe.findCode(" F3 0F ?? ??" + offset.packToHex(4));
    if (offset1 === -1)
    {
        offset1 = pe.findCode(" 0F 10 ??" + offset.packToHex(4));
        var xmmPTR = true;
    }
    if (offset1 === -1)
    {
        return "Failed in Step 1 - clientinfo reference not found";
    }

    if (!xmmPTR)
    {
        var offset2;
        if (ciName == "sclientinfo.xml")
        {
            offset2 = pe.find(" F3 0F ?? ??" + (offset + 8).packToHex(4), offset1, offset1 + 0x20);
            if (offset2 === -1)
            {
                return "Failed in Step 1c - clientinfo reference 2 not found";
            }
        }
        else
        {
            offset2 = pe.find(" A1" + (offset + 8).packToHex(4), offset1 - 10, offset1);
            if (offset2 === -1)
            {
                return "Failed in Step 1c - clientinfo reference 2 not found";
            }

            var offset3 = pe.find(" 66 A1" + (offset + 0xC).packToHex(4), offset1, offset1 + 0x10);
            if (offset3 === -1)
            {
                return "Failed in Step 1c - clientinfo reference 3 not found";
            }

            var offset4 = pe.find(" A0" + (offset + 0xE).packToHex(4), offset1, offset1 + 0x20);
            if (offset4 === -1)
            {
                return "Failed in Step 1c - clientinfo reference 4 not found";
            }
        }
    }

    var myfile = input.getString(
        "$newclientinfo",
        _("String input - maximum 14 characters"),
        _("Enter the new clientinfo path"),
        ciName,
        14
    );
    if (myfile === ciName)
    {
        return "Patch Cancelled - New value is same as old";
    }
    if (myfile.length > 14 || myfile.length < 9)
    {
        return "Patch Cancelled - File name length should between 9 to 14 char";
    }

    var free = alloc.find(myfile.length);
    if (free === -1)
    {
        return "Failed in Step 2b - Not enough free space";
    }

    pe.insertAt(free, myfile.length, myfile);
    if (xmmPTR)
    {
        pe.replaceHex(offset1 + 3, pe.rawToVa(free).packToHex(4));
    }
    else
    {
        pe.replaceHex(offset1 + 4, pe.rawToVa(free).packToHex(4));
        if (ciName == "sclientinfo.xml")
        {
            pe.replaceHex(offset2 + 4, pe.rawToVa(free + 8).packToHex(4));
        }
        else
        {
            pe.replaceHex(offset2 + 1, pe.rawToVa(free + 8).packToHex(4));
            pe.replaceHex(offset3 + 2, pe.rawToVa(free + 0xC).packToHex(4));
            pe.replaceHex(offset4 + 1, pe.rawToVa(free + 0xE).packToHex(4));
        }
    }
    return true;
}

function LoadCustomClientInfo_()
{
    return pe.stringRaw("sclientinfo.xml") !== -1 || pe.stringRaw("clientinfo.xml") !== -1;
}
