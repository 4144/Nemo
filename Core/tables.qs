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

function registerTables()
{
    table.var1 = 0;
    table.g_session = 1;
    table.g_serviceType = 2;
    table.g_windowMgr = 3;
    table.UIWindowMgr_MakeWindow = 4;
    table.UIWindowMgr_DeleteWindow = 5;
    table.g_modeMgr = 6;
    table.g_fileMgr = 7;
    table.g_hMainWnd = 8;
    table.msgStringTable = 9;
    table.CSession_m_accountId = 10;
    table.ITEM_INFO_location = 11;
    table.ITEM_INFO_view_sprite = 12;
    table.cashShopPreviewPatch1 = 13;
    table.cashShopPreviewPatch2 = 14;
    table.cashShopPreviewPatch3 = 15;
    table.cashShopPreviewFlag = 16;
    table.bgCheck1 = 17;
    table.bgCheck2 = 18;
    table.CSession_IsBattleFieldMode = 19;
    table.CSession_GetTalkType_ret = 20;
    table.m_lastLockOnPcGid = 21;
    table.CGameMode_ProcessAutoFollow = 22;
    table.CGameMode_OnUpdate = 23;
    table.g_client_version = 24;
    table.packetVersion = 25;
    table.UIWindowMgr_MakeWindow_ret1 = 31;
    table.UIWindowMgr_MakeWindow_ret2 = 32;
    table.CLua_Load = 38;
    table.CLua_Load_type = 39;
    table.CSession_m_lua_offset = 40;
    table.g_renderer = 41;
    table.g_renderer_m_width = 42;
    table.g_renderer_m_height = 43;
    registerTableFunctions();
}

function table_getRaw(varId)
{
    checkArgs("table.getRaw", arguments, [["Number"]]);
    var ret = table.get(varId);
    if (ret === 0)
        return 0;
    return exe.Rva2Raw(ret);
}

function table_getHex1(varId)
{
    checkArgs("table.getHex1", arguments, [["Number"]]);
    return table.get(varId).packToHex(1);
}

function table_getHex4(varId)
{
    checkArgs("table.getHex4", arguments, [["Number"]]);
    return table.get(varId).packToHex(4);
}

function table_getSessionAbsHex4(varId)
{
    checkArgs("table.getSessionAbsHex4", arguments, [["Number"]]);
    return (table.get(table.g_session) + table.get(varId)).packToHex(4);
}

function getEcxSessionHex()
{
    return "B9 " + table.getHex4(table.g_session);  // mov ecx, g_session
}

function getEcxWindowMgrHex()
{
    return "B9 " + table.getHex4(table.g_windowMgr);  // mov ecx, g_windowMgr
}

function getEcxModeMgrHex()
{
    return "B9 " + table.getHex4(table.g_modeMgr);  // mov ecx, g_modeMgr
}

function getEcxFileMgrHex()
{
    return "B9 " + table.getHex4(table.g_fileMgr);  // mov ecx, g_fileMgr
}

function registerTableFunctions()
{
    table.getHex1 = table_getHex1;
    table.getHex4 = table_getHex4;
    table.getRaw = table_getRaw;
    table.getSessionAbsHex4 = table_getSessionAbsHex4;
}
