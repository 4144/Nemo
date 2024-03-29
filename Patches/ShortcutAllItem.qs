//
// Copyright (C) 2018  CH.C
//
// Hercules is free software: you can redistribute it and/or modify
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

function ShortcutAllItem()
{
    var code =
        " 0F B6 80 ?? ?? ?? 00" +
        " FF 24 85 ?? ?? ?? 00" +
        " 83 BD ?? ?? ?? ?? 00";

    var offsets = pe.findCodes(code);
    if (offsets.length === 0)
    {
        return "Failed in Step 1 - Codes not found";
    }

    var offset = 0;
    for (var i = 0; i < offsets.length; i++)
    {
        offset = offsets[i] + 7;
        code = "90 FF 25";

        pe.replaceHex(offset, code);
    }

    return true;
}
