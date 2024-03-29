//
// Copyright (C) 2021-2023 Andrei Karas (4144)
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

function imports_load()
{
    if (imports.init === true)
    {
        return;
    }

    var descriptor = pe.getImportTable();
    var vaOffset = pe.rawToVa(descriptor.offset);
    if (vaOffset <= 0)
    {
        imports.init = true;
        return;
    }
    for (var i = 0; i < descriptor.size; i += 4 * 5)
    {
        var data = imports.loadDescriptor(descriptor.offset + i);
        if (data === false)
        {
            break;
        }
        imports.parseDescriptor(data);
    }
    imports.init = true;
}

function imports_add(dllName, funcName, funcPtr)
{
    dllName = dllName.toLowerCase();
    imports.allImports.push(dllName, funcName, funcPtr);

    var values = {
        "dll": dllName,
        "name": funcName,
        "ptr": funcPtr,
    };

    function addEntry(key, value)
    {
        if (!(key in imports.nameToPtr))
        {
            imports.nameToPtr[key] = [];
        }
        imports.nameToPtr[key].push(value);
    }

    addEntry([undefined, funcName], values);
    addEntry([dllName, funcName], values);
}

function imports_parseDescriptor(descriptor)
{
    var nameOffset = descriptor.names;
    var funcOffset = descriptor.funcs;
    var dllName = descriptor.dll;

    while (true)
    {
        var offset = pe.fetchUDWord(nameOffset);
        if (offset == 0)
        {
            return;
        }

        var funcPtr;
        if ((offset & 0x80000000) != 0)
        {
            var ordinal = offset & 0x7fffffff;
            funcPtr = pe.rawToVa(funcOffset);
            imports.add(dllName, ordinal, funcPtr);
        }
        else
        {
            offset = pe.rvaToRaw(offset);
            if (offset < 0)
            {
                return;
            }
            var funcName = pe.fetchString(offset + 2);
            funcPtr = pe.rawToVa(funcOffset);
            imports.add(dllName, funcName, funcPtr);
        }
        nameOffset += 4;
        funcOffset += 4;
    }
}

function imports_loadDescriptor(offset)
{
    var nameList = pe.fetchUDWord(offset);
    if (nameList === 0)
    {
        return false;
    }
    nameList = pe.rvaToRaw(nameList);
    var forwarded = pe.fetchUDWord(offset + 8);
    if (forwarded != 0)
    {
        throw "Unsupported import table flag";
    }
    var dllName = pe.fetchUDWord(offset + 12);
    if (dllName === 0)
    {
        return false;
    }
    dllName = pe.fetchString(pe.rvaToRaw(dllName));
    if (dllName.length < 4 || dllName.toLowerCase().indexOf(".dll") < 1)
    {
        return false;
    }
    var funcList = pe.fetchUDWord(offset + 16);
    if (funcList === 0)
    {
        return false;
    }
    funcList = pe.rvaToRaw(funcList);
    return {
        "names": nameList,
        "dll": dllName,
        "funcs": funcList,
    };
}

function imports_importByName(funcName, dllName)
{
    if (typeof testGetImport !== "undefined")
    {
        var offset = testGetImport(funcName, dllName);
        if (offset === -1)
        {
            return false;
        }
        if (offset !== false)
        {
            return offset;
        }
    }

    imports.load();
    if (typeof dllName !== "undefined")
    {
        dllName = dllName.toLowerCase();
    }
    var key = [dllName, funcName];
    if (key in imports.nameToPtr)
    {
        var arr = imports.nameToPtr[key];
        if (typeof testSetImport !== "undefined")
        {
            testSetImport(funcName, dllName, arr[0]);
        }
        return arr[0];
    }

    if (typeof testSetImport !== "undefined")
    {
        testSetImport(funcName, dllName, false);
    }
    return false;
}

function imports_ptr(funcName, dllName, ordinal)
{
    var entry = imports.importByName(funcName, dllName);
    if (entry === false && typeof ordinal !== "undefined")
    {
        entry = imports.importByName(ordinal, dllName);
    }
    if (entry === false)
    {
        return -1;
    }
    return entry.ptr;
}

function imports_ptrValidated(funcName, dllName, ordinal)
{
    var entry = imports_ptr(funcName, dllName, ordinal);
    if (entry === -1)
    {
        throw "Import function " + dllName + ":" + funcName + " not found";
    }
    return entry;
}

function imports_ptrHexValidated(funcName, dllName, ordinal)
{
    var entry = imports_ptr(funcName, dllName, ordinal);
    if (entry === -1)
    {
        throw "Import function " + dllName + ":" + funcName + " not found";
    }
    return entry.packToHex(4);
}

function registerImports()
{
    imports = {};
    imports.init = false;
    imports.allImports = [];
    imports.nameToPtr = {};

    imports.load = imports_load;
    imports.loadDescriptor = imports_loadDescriptor;
    imports.parseDescriptor = imports_parseDescriptor;
    imports.add = imports_add;
    imports.importByName = imports_importByName;
    imports.ptr = imports_ptr;
    imports.ptrValidated = imports_ptrValidated;
    imports.ptrHexValidated = imports_ptrHexValidated;
}
