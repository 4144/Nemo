//
// Copyright (C) 2020-2021  Andrei Karas (4144)
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

function exe_setJmpVa(patchAddr, jmpAddrVa, cmd, codeLen)
{
    if (typeof(cmd) === "undefined")
        cmd = "jmp";
    var vars = {
        "offset": jmpAddrVa,
    };
    var code = asm.textToHexRaw(patchAddr, cmd + " offset", vars);
    if (code === false)
        throw "Jmp code error";

    if (typeof(codeLen) !== "undefined")
    {
        var sz = code.hexlength();
        if (sz > codeLen)
            throw "Jmp Code bigger than requested";
        for (var i = 0; i < codeLen - sz; i ++)
        {
            code = code + " 90";
        }
    }

    exe.replace(patchAddr, code, PTYPE_HEX);
}

function exe_setJmpRaw(patchAddr, jmpAddrRaw, cmd, codeLen)
{
    exe_setJmpVa(patchAddr, exe.Raw2Rva(jmpAddrRaw), cmd, codeLen);
}

function exe_setNops(patchAddr, nopsCount)
{
    var code = "";
    for (var i = 0; i < nopsCount; i ++)
    {
        code = code + "90 ";
    }
    exe.replace(patchAddr, code, PTYPE_HEX);
}

function exe_setNopsRange(patchStartAddr, patchEndAddr)
{
    exe_setNops(patchStartAddr, patchEndAddr - patchStartAddr);
}

function exe_insertAsmText(commands, vars)
{
    var size = asm.textToHexLength(commands, vars);
    if (size === false)
        throw "Asm code error1";

    var free = exe.findZeros(size);
    if (free === -1)
        throw "Failed in exe.insertAsm - Not enough free space";

    var obj = asm.textToObjRaw(free, commands, vars);
    if (obj === false)
        throw "Asm code error";

    exe.insert(free, size, obj.code, PTYPE_HEX);
    return [free, obj.code, obj.vars];
}

function exe_insertAsmTextObj(commands, vars)
{
    var size = asm.textToHexLength(commands, vars);
    if (size === false)
        throw "Asm code error";

    var free = exe.findZeros(size);
    if (free === -1)
        throw "Failed in exe.insertAsm - Not enough free space";

    var obj = asm.textToObjRaw(free, commands, vars);
    if (obj === false)
        throw "Asm code error";

    exe.insert(free, size, obj.code, PTYPE_HEX);
    obj.free = free;
    return obj;
}

function exe_replaceAsmText(patchAddr, commands, vars)
{
    var obj = asm.textToHexRaw(patchAddr, commands, vars);
    if (obj === false)
        throw "Asm code error";

    exe.replace(patchAddr, obj, PTYPE_HEX);
    return obj;
}

function exe_match(code, useMask, addrRaw)
{
    reportLegacy("Please replace exe.match to pe.match");

    var offset = exe.find(code, PTYPE_HEX, useMask, "\xAB", addrRaw, addrRaw + 1);
    if (offset !== addrRaw)
        return false;
    return true;
}

function exe_fetchValue(offset, offset2)
{
    var size = offset2[1];
    var addr = offset + offset2[0];
    if (size == 1)
    {
        return exe.fetchByte(addr);
    }
    else if (size == 2)
    {
        return exe.fetchWord(addr);
    }
    else if (size == 4)
    {
        return exe.fetchDWord(addr);
    }
    else if (size == 8)
    {
        return exe.fetchQWord(addr);
    }
    else
    {
        throw "Unknown size in exe.fetchValue: " + size;
    }
}

function exe_setValue(offset, offset2, value)
{
    var size = offset2[1];
    var addr = offset + offset2[0];
    exe.replace(addr, value.packToHex(size), PTYPE_HEX);
}

function exe_setShortJmpVa(patchAddr, jmpAddrVa, cmd)
{
    if (typeof(cmd) === "undefined")
        cmd = "jmp";
    var vars = {
        "offset": jmpAddrVa,
    };
    var code = asm.textToHexRaw(patchAddr, cmd + " offset", vars);
    if (code === false)
        throw "Jmp code error";

    if (code.hexlength() !== 2)
        throw cmd + " is not short";

    exe.replace(patchAddr, code, PTYPE_HEX);
}

function exe_setShortJmpRaw(patchAddr, jmpAddrRaw, cmd)
{
    exe_setShortJmpVa(patchAddr, exe.Raw2Rva(jmpAddrRaw), cmd);
}

function exe_fetchRelativeValue(offset, offset2)
{
    var value = exe_fetchValue(offset, offset2);
    var addr = exe.Raw2Rva(offset + offset2[0]) + offset2[1] + value;
    return addr;
}

function exe_fetchHexBytes(offset, offset2)
{
    var size = offset2[1];
    var addr = offset + offset2[0];
    return exe.fetchHex(addr, size);
}

function registerExe()
{
    exe.setJmpVa = exe_setJmpVa;
    exe.setJmpRaw = exe_setJmpRaw;
    exe.setNops = exe_setNops;
    exe.setNopsRange = exe_setNopsRange;
    exe.insertAsmText = exe_insertAsmText;
    exe.insertAsmTextObj = exe_insertAsmTextObj;
    exe.replaceAsmText = exe_replaceAsmText;
    exe.match = exe_match;
    exe.fetchValue = exe_fetchValue;
    exe.fetchHexBytes = exe_fetchHexBytes;
    exe.setValue = exe_setValue;
    exe.setShortJmpRaw = exe_setShortJmpRaw;
    exe.setShortJmpVa = exe_setShortJmpVa;
    exe.fetchRelativeValue = exe_fetchRelativeValue;
    registerExeLegacy();
}
