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

function ButtonNew(buttonId, value)
{
    var offset = pe.stringRaw("adventurerAgency");
    if (offset === -1)
    {
        throw "Failed in Step 1 - String not found";
    }

    offset = pe.findCode("68" + pe.rawToVa(offset).packToHex(4));
    if (offset === -1)
    {
        throw "Failed in Step 2 - String reference missing";
    }

    var code =
        "0F B6 80 ?? ?? ?? ?? " +
        "FF 24 85 ";
    var switchTblOffset = 3;
    offset = pe.find(code, offset, offset + 0xA0);

    if (offset === -1)
    {
        throw "Failed in Step 3 - Button display table not found";
    }

    var switchTbl = pe.vaToRaw(pe.fetchDWord(offset + switchTblOffset));

    var valueOffset = switchTbl + buttonId - 0x169;

    var oldValue = pe.fetchByte(valueOffset);
    if (valueOffset < switchTbl)
    {
        throw "Failed in Step 4 - button switch pointer before switch table start";
    }
    if (oldValue !== 0 && oldValue !== 1)
    {
        throw "Failed in Step 4 - default button show value: " + oldValue;
    }

    pe.replaceByte(valueOffset, value);

    return true;
}

function NavigationButton()
{
    return ButtonNew(0x197 + 5, exe.getUserInput("$navi", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function BankButton()
{
    return ButtonNew(0x1B6 + 5, exe.getUserInput("$bank", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function ReplayButton()
{
    return ButtonNew(0x178 + 5, exe.getUserInput("$replay", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function MailButton()
{
    return ButtonNew(0x1C5 + 5, exe.getUserInput("$mail", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function AchievementButton()
{
    return ButtonNew(0x1C2 + 5, exe.getUserInput("$achievement", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function TipButton()
{
    return ButtonNew(0x1E8 + 5, exe.getUserInput("$tip", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function ShopButton()
{
    return ButtonNew(0x1E9 + 5, exe.getUserInput("$shop", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function SNSButton()
{
    return ButtonNew(0x1EF + 5, exe.getUserInput("$sns", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function AttendanceButton()
{
    return ButtonNew(0x205 + 5, exe.getUserInput("$attendance", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function BookingButton()
{
    return ButtonNew(0x169, exe.getUserInput("$booking", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function AdventurerAgencyButton()
{
    return ButtonNew(0x20E, exe.getUserInput("$adventurerAgency", XTYPE_BYTE, _("Set Button"), _("Set Button Hide(0) or Show(1)"), 0, 0, 1));
}

function NavigationButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}

function BankButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}

function ReplayButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}

function MailButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}

function AchievementButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}

function TipButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}

function ShopButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}

function SNSButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}

function AttendanceButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}

function BookingButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}

function AdventurerAgencyButton_()
{
    return pe.stringVa("adventurerAgency") !== -1;
}
